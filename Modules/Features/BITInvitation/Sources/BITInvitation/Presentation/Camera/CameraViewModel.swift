import AVFoundation
import BITAnalytics
import BITAnyCredentialFormat
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
class CameraViewModel: ObservableObject {

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

  @Published public var isTipPresented: Bool = true
  @Published public var qrScannerError: Error? = nil
  @Published public var isScannerActive: Bool = true
  @Published public var isLoading: Bool = false
  @Published public var isPopupErrorPresented: Bool = false

  @Published public var offer: CredentialOffer?

  @Published public var isTorchEnabled: Bool = false {
    didSet {
      isTorchEnabled ? cameraManager.flashlight.turnOn() : cameraManager.flashlight.turnOff()
    }
  }

  // MARK: Internal

  enum CameraError: Error {
    case noCredentialsInWallet
    case noCompatibleCredentials

    case noInternetConnexion
    case expiredInvitation
    case unavailableCredential
    case unknownQRCode

    case invalidRequestObject
  }

  @ObservedObject var cameraManager = CameraManager()

  var session: AVCaptureSession = .init()

  @Published var credential: Credential?
  @Published var qrCodeObject: AVMetadataMachineReadableCodeObject?

  func openExternalLink() {
    guard let invitationError = qrScannerError as? CameraError, let link = invitationError.link, let url = URL(string: link) else {
      return
    }

    router.openExternalLink(url: url)
  }

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
      let url = URL(string: urlString)
    else { return }
    vibrate()
    cameraManager.stop()

    Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
      DispatchQueue.main.async { [weak self] in
        self?.cameraManager.start()
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
  private var processPresentation: Bool = false
  private var processCredentialOffer: Bool = false
  private var bag: Set<AnyCancellable> = []

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
    isLoading = true

    try? await Task.sleep(nanoseconds: 500_000_000)

    invitationURL = url
    return try await checkInvitationTypeUseCase.execute(url: url)
  }

  private func handleError(_ error: Error) {
    isLoading = false

    analytics.log(error)

    if let error = error as? NetworkError {
      switch error.status {
      case .noConnection:
        qrScannerError = CameraError.noInternetConnexion
      default:
        qrScannerError = CameraError.unknownQRCode
      }
    } else if error as? FetchCredentialError == .expiredInvitation {
      isTorchEnabled = false
      invitationURL = nil

      qrScannerError = CameraError.expiredInvitation
    } else if
      error as? FetchCredentialError == .verificationFailed
    {
      isTorchEnabled = false
      invitationURL = nil
      qrScannerError = CameraError.unavailableCredential
    } else if error as? CompatibleCredentialsError == .noCredentialsInWallet {
      isTorchEnabled = false
      invitationURL = nil
      qrScannerError = CameraError.noCredentialsInWallet
    } else if error as? CompatibleCredentialsError == .noCompatibleCredentials {
      isTorchEnabled = false
      invitationURL = nil
      qrScannerError = CameraError.noCompatibleCredentials
    } else {
      invitationURL = nil
      qrScannerError = CameraError.unknownQRCode
    }

    showErrorView()

    processPresentation = false
    processCredentialOffer = false
  }

}

// MARK: - Receive flow

extension CameraViewModel {

  private func fetchAndSaveCredential(from offer: CredentialOffer) async throws -> Credential {
    guard let issuerUrl = URL(string: offer.issuer) else {
      throw CameraError.unavailableCredential
    }

    guard let selectedCredentialId = offer.credentialConfigurationIds.first else {
      throw CameraError.unavailableCredential
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
      return try router.compatibleCredentials(for: id, and: context)
    }

    guard
      let id = context.requestObject.presentationDefinition.inputDescriptors.first?.id,
      let credential = context.requests[id]?.first else { throw CameraError.invalidRequestObject }
    context.selectedCredentials[id] = credential
    isTorchEnabled = false
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
  var primaryText: String {
    switch self {
    case .noInternetConnexion: L10n.tkErrorConnectionproblemTitle
    case .noCredentialsInWallet: L10n.tkErrorEmptywalletTitle
    case .noCompatibleCredentials: L10n.tkErrorNosuchcredentialTitle
    case .expiredInvitation: L10n.tkErrorNotusableTitle
    case .unavailableCredential: L10n.tkErrorInvalidrequestTitle
    case .unknownQRCode: L10n.tkErrorInvalidqrcodeTitle
    case .invalidRequestObject: L10n.tkErrorInvalidrequestTitle
    }
  }

  var secondaryText: String {
    switch self {
    case .noInternetConnexion: L10n.tkErrorConnectionproblemBody
    case .noCredentialsInWallet: L10n.tkErrorEmptywalletBody
    case .noCompatibleCredentials: L10n.tkErrorNosuchcredentialBody
    case .expiredInvitation: L10n.tkErrorNotusableBody
    case .unavailableCredential: L10n.tkErrorInvalidrequestBody
    case .unknownQRCode: L10n.tkErrorInvalidqrcodeBody
    case .invalidRequestObject: L10n.tkErrorInvalidrequestBody
    }
  }

  var tertiaryText: String? {
    switch self {
    case .expiredInvitation,
         .invalidRequestObject,
         .noCompatibleCredentials,
         .noInternetConnexion,
         .unavailableCredential: nil
    case .noCredentialsInWallet: L10n.tkQrscannerInvalidcodeLinkText
    case .unknownQRCode: L10n.tkQrscannerInvalidcodeLinkText
    }
  }

  var icon: String {
    switch self {
    case .noInternetConnexion: "wifi"
    case .noCredentialsInWallet: ""
    case .noCompatibleCredentials: ""
    case .expiredInvitation: "qrcode"
    case .unavailableCredential: "person.crop.square"
    case .unknownQRCode: "questionmark.square"
    case .invalidRequestObject: ""
    }
  }

  var link: String? {
    switch self {
    case .invalidRequestObject,
         .noCompatibleCredentials,
         .noCredentialsInWallet,
         .noInternetConnexion: nil
    case .expiredInvitation,
         .unavailableCredential,
         .unknownQRCode: "https://www.eid.admin.ch/en"
    }
  }
}

extension CameraViewModel {

  // MARK: Internal

  static let hapticFeedbackGenerator: UIImpactFeedbackGenerator = .init(style: .medium)

  // MARK: Private

  private func vibrate() {
    Self.hapticFeedbackGenerator.impactOccurred()
  }
}
