import BITAnalytics
import BITCredentialShared
import Factory
import Foundation
import UIKit

// MARK: - CredentialDetailViewModel

@MainActor
class CredentialDetailViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    _ credential: Credential,
    router: CredentialDetailRouterRoutes = Container.shared.credentialDetailRouter(),
    deleteCredentialUseCase: DeleteCredentialUseCaseProtocol = Container.shared.deleteCredentialUseCase(),
    checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol = Container.shared.checkAndUpdateCredentialStatusUseCase(),
    analytics: AnalyticsProtocol = Container.shared.analytics())
  {
    self.credential = credential
    self.checkAndUpdateCredentialStatusUseCase = checkAndUpdateCredentialStatusUseCase
    self.analytics = analytics
    self.router = router
    self.deleteCredentialUseCase = deleteCredentialUseCase
    credentialBody = CredentialDetailBody(from: credential)
    configureObservers()
  }

  // MARK: Internal

  enum AnalyticsEvent: AnalyticsEventProtocol {
    case checkStatusFailed
    case deleteCredentialError(_ error: Error)
  }

  @Published var credentialBody: CredentialDetailBody
  @Published var isDeleteCredentialAlertPresented = false

  @Published var credential: Credential {
    didSet {
      credentialBody = CredentialDetailBody(from: credential)
    }
  }

  func deleteCredential() async {
    do {
      try await deleteCredentialUseCase.execute(credential)
      close()
    } catch {
      analytics.log(AnalyticsEvent.deleteCredentialError(error))
    }
  }

  func onAppear() async {
    await updateCredentialStatus()
  }

  func refresh() async {
    await updateCredentialStatus()
  }

  func openWrongdata() {
    router.wrongData()
  }

  func close() {
    router.close()
  }

  // MARK: Private

  private let analytics: AnalyticsProtocol
  private let router: CredentialDetailRouterRoutes
  private let deleteCredentialUseCase: DeleteCredentialUseCaseProtocol
  private let checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol

  private func updateCredentialStatus() async {
    guard let credential = try? await checkAndUpdateCredentialStatusUseCase.execute(for: credential) else {
      return analytics.log(AnalyticsEvent.checkStatusFailed)
    }

    self.credential = credential
  }

  private func configureObservers() {
    NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
      Task { @MainActor [weak self] in
        self?.isDeleteCredentialAlertPresented = false
      }
    }
  }
}
