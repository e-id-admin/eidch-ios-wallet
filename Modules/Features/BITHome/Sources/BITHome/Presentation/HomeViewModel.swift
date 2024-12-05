import BITAnalytics
import BITAppAuth
import BITCore
import BITCredential
import BITCredentialShared
import BITDataStore
import BITEntities
import BITL10n
import Combine
import Factory
import Foundation
import RealmSwift

// MARK: - HomeViewModel

public class HomeViewModel: StateMachine<HomeViewModel.State, HomeViewModel.Event> {

  // MARK: Lifecycle

  public init(
    _ initialState: State = .results,
    router: HomeRouterRoutes,
    credentials: [Credential] = [],
    notificationCenter: NotificationCenter = NotificationCenter.default,
    getCredentialListUseCase: GetCredentialListUseCaseProtocol = Container.shared.getCredentialListUseCase(),
    checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol = Container.shared.checkAndUpdateCredentialStatusUseCase(),
    isUserLoggedInUseCase: IsUserLoggedInUseCaseProtocol = Container.shared.isUserLoggedInUseCase(),
    analytics: AnalyticsProtocol = Container.shared.analytics())
  {
    self.credentials = credentials
    self.getCredentialListUseCase = getCredentialListUseCase
    self.checkAndUpdateCredentialStatusUseCase = checkAndUpdateCredentialStatusUseCase
    self.router = router
    self.notificationCenter = notificationCenter
    self.analytics = analytics
    self.isUserLoggedInUseCase = isUserLoggedInUseCase

    super.init(initialState)
    registerNotifications()
  }

  // MARK: Public

  public enum State: Equatable {
    case results
    case error
    case empty
  }

  public enum Event {
    case fetchCredentials
    case didFetchCredentials(_ credentials: [Credential])
    case checkCredentialsStatus
    case didCheckCredentialsStatus
    case didCheckCredentialsStatusWithError(_ error: Error)

    case refresh

    case setError(_ error: Error)
  }

  override public func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch (state, event) {
    case (_, .fetchCredentials):
      guard isUserLoggedInUseCase.execute() else { return nil }
      return AnyPublisher.run {
        try await self.getCredentialListUseCase.execute()
      } onSuccess: { credentials in
        .didFetchCredentials(credentials)
      } onError: { error in
        .setError(error)
      }

    case (_, .didFetchCredentials(let credentials)):
      stateError = nil

      if credentials.isEmpty {
        state = .empty
        return nil
      }

      self.credentials = credentials
      state = .results

    case (_, .refresh):
      guard isUserLoggedInUseCase.execute() else { return nil }
      return Just(.fetchCredentials).eraseToAnyPublisher()

    case (_, .checkCredentialsStatus):
      guard isUserLoggedInUseCase.execute() else { return nil }
      return AnyPublisher.run {
        try await self.checkAndUpdateCredentialStatusUseCase.execute(self.credentials)
      } onSuccess: { _ in
        .didCheckCredentialsStatus
      } onError: { error in
        self.analytics.log(error)
        return .didCheckCredentialsStatusWithError(error)
      }

    case (_, .didCheckCredentialsStatus),
         (_, .didCheckCredentialsStatusWithError(_)):
      return nil

    case (_, .setError(let error)):
      analytics.log(error)

      if credentials.isEmpty {
        state = .error
      }

      stateError = error
    }

    return nil
  }

  // MARK: Internal

  @Published var credentials: [Credential] = []
  @Published var isImpressumPresented = false
  @Published var isSecurityPresented = false
  @Published var isLicensesPresented = false
  @Published var isVerificationInstructionPresented = false

  func openScanner() {
    router.invitation()
  }

  func openSettings() {
    router.settings()
  }

  func openHelp() {
    guard let url = URL(string: L10n.settingsHelpLink) else { return }
    router.openExternalLink(url: url)
  }

  func openContact() {
    guard let url = URL(string: L10n.settingsContactLink) else { return }
    router.openExternalLink(url: url)
  }

  func openImpressum() {
    isImpressumPresented = true
  }

  func openLicenses() {
    isLicensesPresented = true
  }

  func openSecurity() {
    isSecurityPresented = true
  }

  func openDetail(for credential: Credential) {
    router.credentialDetail(credential)
  }

  // MARK: Private

  private let router: HomeRouterRoutes

  private let notificationCenter: NotificationCenter
  private let getCredentialListUseCase: GetCredentialListUseCaseProtocol
  private let checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol
  private let isUserLoggedInUseCase: IsUserLoggedInUseCaseProtocol
  private let analytics: AnalyticsProtocol

  private var credentialObjectsDidChangeNotification: NotificationToken?

  private func registerNotifications() {
    notificationCenter.addObserver(forName: .didLogin, object: nil, queue: .main, using: { [weak self] _ in self?.onDidLogin() })
  }

  private func onDidLogin() {
    credentialObjectsDidChangeNotification = try? Container.shared.dataStore()
      .get(CredentialEntity.self)
      .observe { [weak self] changes in
        guard let self else { return }
        switch changes {
        case .update:
          Task {
            await self.send(event: .refresh)
          }
        default:
          return
        }
      }

    Task {
      await send(event: .refresh)
      await send(event: .checkCredentialsStatus)
    }
  }

}
