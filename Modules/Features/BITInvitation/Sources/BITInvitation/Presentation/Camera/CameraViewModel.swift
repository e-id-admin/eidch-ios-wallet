import AVFoundation
import BITAnalytics
import BITAnyCredentialFormat
import BITCore
import BITCredential
import BITCredentialShared
import BITL10n
import BITNetworking
import BITOpenID
import BITPresentation
import BITQRScanner
import Combine
import Factory
import SwiftUI

// MARK: - CameraViewModel

@MainActor
class CameraViewModel: ObservableObject, Vibrating {

  // MARK: Lifecycle

  init(router: InvitationRouterRoutes) {
    self.router = router
    configureBindings()

    session = cameraManager.session
    try? cameraManager.configure()
  }

  init(url: URL, router: InvitationRouterRoutes) {
    self.router = router
    scannerDelay = 0

    Task {
      await setMetadataUrl(url)
    }
  }

  deinit {
    DispatchQueue.main.async { [weak self] in
      self?.cameraManager.stop()
    }
  }

  // MARK: Public

  @Published public var isTipPresented = true
  @Published public var qrScannerError: Error? = nil
  @Published public var isScannerActive = true
  @Published public var isLoading = false
  @Published public var isPopupErrorPresented = false

  @Published public var offer: CredentialOffer?

  @Published public var isTorchEnabled = false {
    didSet {
      isTorchEnabled ? cameraManager.flashlight.turnOn() : cameraManager.flashlight.turnOff()
    }
  }

  // MARK: Internal

  enum CameraError: Error {
    case emptyWallet
    case compatibleCredentialNotFound

    case noConnection
    case expiredInvitation
    case unknownIssuer
    case validationFailed
    case invalidQRCode

    case invalidPresentationRequest
  }

  @ObservedObject var cameraManager = CameraManager()

  var session = AVCaptureSession()

  @Published var credential: Credential?
  @Published var qrCodeObject: AVMetadataMachineReadableCodeObject?

  func close() {
    router.close()
  }

  func showErrorView() {
    isTipPresented = false
    isPopupErrorPresented = true

    Task {
      try? await Task.sleep(nanoseconds: scannerDelay)
      isScannerActive = true
    }
  }

  func closeErrorView() {
    isPopupErrorPresented = false
  }

  func closeTipView() {
    isTipPresented = false
  }

  func toggleTorch() {
    isTorchEnabled.toggle()
  }

  func didMoveFocusArea(to object: AVMetadataMachineReadableCodeObject) {
    guard
      !isLoading,
      let urlString = object.stringValue,
      urlString != previousUrl,
      let url = URL(string: urlString)
    else { return }
    previousUrl = urlString
    vibrate(.success)

    Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
      DispatchQueue.main.async { [weak self] in
        self?.previousUrl = nil
      }
    }

    Task {
      await self.setMetadataUrl(url)
    }
  }

  func setMetadataUrl(_ url: URL) async {
    do {
      let invitationType = try await checkInvitationType(url)

      switch invitationType {
      case .credentialOffer:
        try await processCredentialOffer(url: url)
      case .presentation:
        try await processPresentation(url: url)
      }
    } catch {
      handleError(error)
    }
  }

  func onAppear() async {
    cameraManager.start()
    do {
      isTipPresented = try await getCredentialsCountUseCase.execute() == 0
    } catch {
      isTipPresented = true
    }
  }

  // MARK: Private

  private var invitationURL: URL?
  private var router: InvitationRouterRoutes
  private var processPresentation = false
  private var processCredentialOffer = false
  private var bag: Set<AnyCancellable> = []
  private var previousUrl: String?

  @Injected(\.scannerDelay) private var scannerDelay: UInt64
  @Injected(\.analytics) private var analytics: AnalyticsProtocol
  @Injected(\.fetchMetadataUseCase) private var fetchMetadataUseCase: FetchMetadataUseCaseProtocol
  @Injected(\.saveCredentialUseCase) private var saveCredentialUseCase: SaveCredentialUseCaseProtocol
  @Injected(\.fetchCredentialUseCase) private var fetchCredentialUseCase: FetchCredentialUseCaseProtocol
  @Injected(\.denyPresentationUseCase) private var denyPresentationUseCase: DenyPresentationUseCaseProtocol
  @Injected(\.fetchRequestObjectUseCase) private var fetchRequestObjectUseCase: FetchRequestObjectUseCaseProtocol
  @Injected(\.createAnyCredentialUseCase) private var createAnyCredentialUseCase: CreateAnyCredentialUseCaseProtocol
  @Injected(\.getCredentialsCountUseCase) private var getCredentialsCountUseCase: GetCredentialsCountUseCaseProtocol
  @Injected(\.fetchTrustStatementUseCase) private var fetchTrustStatementUseCase: FetchTrustStatementUseCaseProtocol
  @Injected(\.checkInvitationTypeUseCase) private var checkInvitationTypeUseCase: CheckInvitationTypeUseCaseProtocol
  @Injected(\.validateRequestObjectUseCase) private var validateRequestObjectUseCase: ValidateRequestObjectUseCaseProtocol
  @Injected(\.getCompatibleCredentialsUseCase) private var getCompatibleCredentialsUseCase: GetCompatibleCredentialsUseCaseProtocol
  @Injected(\.checkAndUpdateCredentialStatusUseCase) private var checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol
  @Injected(\.validateCredentialOfferInvitationUrlUseCase) private var validateCredentialOfferInvitationUrlUseCase: ValidateCredentialOfferInvitationUrlUseCaseProtocol

  private func configureBindings() {
    cameraManager.$capturedObject.sink { [weak self] qrcode in
      guard
        let self,
        let qrcode,
        qrcode != qrCodeObject
      else { return }

      qrCodeObject = qrcode
    }.store(in: &bag)
  }

  private func checkInvitationType(_ url: URL) async throws -> InvitationType {
    isScannerActive = false
    isPopupErrorPresented = false
    isLoading = true

    try? await Task.sleep(nanoseconds: 500_000_000)

    invitationURL = url
    return try await checkInvitationTypeUseCase.execute(url: url)
  }

  private func handleError(_ error: Error) {
    vibrate(.error)
    isLoading = false
    analytics.log(error)

    if let error = error as? NetworkError {
      switch error.status {
      case .noConnection:
        qrScannerError = CameraError.noConnection
      default:
        qrScannerError = CameraError.invalidQRCode
      }
    } else if let fetchError = error as? FetchCredentialError {
      resetTorchAndInvitation()
      switch fetchError {
      case .expiredInvitation:
        qrScannerError = CameraError.expiredInvitation
      case .unknownIssuer:
        qrScannerError = CameraError.unknownIssuer
      case .validationFailed:
        qrScannerError = CameraError.validationFailed
      default:
        qrScannerError = CameraError.invalidQRCode
      }
    } else if let credentialsError = error as? CompatibleCredentialsError {
      resetTorchAndInvitation()
      switch credentialsError {
      case .emptyWallet:
        qrScannerError = CameraError.emptyWallet
      case .compatibleCredentialNotFound:
        qrScannerError = CameraError.compatibleCredentialNotFound
      }
    } else {
      invitationURL = nil // Keep the torch enabled
      qrScannerError = CameraError.invalidQRCode
    }

    showErrorView()
    processPresentation = false
    processCredentialOffer = false
  }

  private func resetTorchAndInvitation() {
    isTorchEnabled = false
    invitationURL = nil
  }

}

// MARK: - Receive flow

extension CameraViewModel {

  private func fetchAndSaveCredential(from offer: CredentialOffer) async throws -> Credential {
    guard let issuerUrl = URL(string: offer.issuer) else {
      throw CameraError.validationFailed
    }

    guard let selectedCredentialId = offer.credentialConfigurationIds.first else {
      throw CameraError.validationFailed
    }

    let metadata = try await fetchMetadataUseCase.execute(from: issuerUrl)
    let metadataWrapper = CredentialMetadataWrapper(selectedCredentialSupportedId: selectedCredentialId, credentialMetadata: metadata)

    let credentialWithKeyBinding = try await fetchCredentialUseCase.execute(from: issuerUrl, metadataWrapper: metadataWrapper, credentialOffer: offer, accessToken: nil)
    let credential = try await saveCredentialUseCase.execute(credentialWithKeyBinding: credentialWithKeyBinding, metadataWrapper: metadataWrapper)

    do {
      return try await checkAndUpdateCredentialStatusUseCase.execute(for: credential)
    } catch {
      return credential
    }
  }

  private func processCredentialOffer(url: URL) async throws {
    processCredentialOffer = true
    let credentialOffer = try validateCredentialOfferInvitationUrlUseCase.execute(url)
    credential = try await fetchAndSaveCredential(from: credentialOffer)

    isLoading = false
    cameraManager.flashlight.turnOff()
    processCredentialOffer = false

    if let credential {
      let trustStatement = await fetchTrustStatement(for: credential)

      cameraManager.stop()
      router.credentialOffer(credential: credential, trustStatement: trustStatement)
    }
  }

  private func fetchTrustStatement(for credential: Credential) async -> TrustStatement? {
    guard let anyCredential = try? createAnyCredentialUseCase.execute(from: credential.payload, format: credential.format) else {
      return nil
    }

    return try? await fetchTrustStatementUseCase.execute(credential: anyCredential)
  }
}

// MARK: - Presentation flow

extension CameraViewModel {

  private func processPresentation(url: URL) async throws {
    processPresentation = true
    let requestObject = try await fetchRequestObjectUseCase.execute(url)
    let context = PresentationRequestContext(requestObject: requestObject)

    guard await validateRequestObjectUseCase.execute(context.requestObject) else {
      return try await denyPresentationUseCase.execute(context: context, error: .invalidRequest)
    }

    if let jwtRequestObject = requestObject as? JWTRequestObject {
      let trustStatement = try? await fetchTrustStatementUseCase.execute(jwtRequestObject: jwtRequestObject)
      context.trustStatement = trustStatement
    }

    let compatibleCredentials = try await getCompatibleCredentialsUseCase.execute(using: requestObject)
    context.requests = compatibleCredentials

    isLoading = false

    if let id = getFirstCompatibleCredentialInputDescriptorID(from: context) {
      cameraManager.stop()
      return try router.compatibleCredentials(for: id, and: context)
    }

    guard
      let id = context.requestObject.presentationDefinition.inputDescriptors.first?.id,
      let credential = context.requests[id]?.first else { throw CameraError.invalidPresentationRequest }
    context.selectedCredentials[id] = credential
    isTorchEnabled = false
    cameraManager.stop()
    return router.presentationReview(with: context)
  }

  private func getFirstCompatibleCredentialInputDescriptorID(from context: PresentationRequestContext) -> InputDescriptorID? {
    let filteredRequestIDs = Set(context.requests.filter { $0.value.count > 1 }.keys)

    guard !filteredRequestIDs.isEmpty else {
      return nil
    }

    return context.requestObject.presentationDefinition.inputDescriptors
      .map(\.id)
      .first { filteredRequestIDs.contains($0) }
  }
}

extension CameraViewModel.CameraError {

  var icon: Image {
    switch self {
    case .noConnection: Assets.noWifi.swiftUIImage
    case .compatibleCredentialNotFound,
         .emptyWallet,
         .expiredInvitation: Assets.credential.swiftUIImage
    case .invalidPresentationRequest,
         .unknownIssuer,
         .validationFailed: Assets.questionmarkSquare.swiftUIImage
    case .invalidQRCode: Assets.qrcode.swiftUIImage
    }
  }

  var primaryText: String {
    switch self {
    case .noConnection: L10n.tkErrorConnectionproblemTitle
    case .emptyWallet: L10n.tkErrorEmptywalletTitle
    case .compatibleCredentialNotFound: L10n.tkErrorNosuchcredentialTitle
    case .expiredInvitation: L10n.tkErrorInvitationcredentialTitle
    case .unknownIssuer: L10n.tkErrorNotregisteredTitle
    case .validationFailed: L10n.tkErrorNotregisteredTitle
    case .invalidQRCode: L10n.tkErrorNotusableTitle
    case .invalidPresentationRequest: L10n.tkErrorInvalidrequestTitle
    }
  }

  var secondaryText: String {
    switch self {
    case .noConnection: L10n.tkErrorConnectionproblemBody
    case .emptyWallet: L10n.tkErrorEmptywalletBody
    case .compatibleCredentialNotFound: L10n.tkErrorNosuchcredentialBody
    case .expiredInvitation: L10n.tkErrorInvitationcredentialBody
    case .unknownIssuer: L10n.tkErrorNotregisteredBody
    case .validationFailed: L10n.tkErrorNotregisteredBody
    case .invalidQRCode: L10n.tkErrorNotusableBody
    case .invalidPresentationRequest: L10n.tkErrorInvalidrequestBody
    }
  }

}
