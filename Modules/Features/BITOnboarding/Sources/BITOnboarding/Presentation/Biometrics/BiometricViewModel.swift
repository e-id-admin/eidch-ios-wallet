import BITAnalytics
import BITAppAuth
import BITL10n
import BITLocalAuthentication
import BITSettings
import Factory
import Foundation
import SwiftUI

// MARK: - BiometricViewModel

@MainActor
class BiometricViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    router: OnboardingInternalRoutes,
    getBiometricTypeUseCase: GetBiometricTypeUseCaseProtocol = Container.shared.getBiometricTypeUseCase(),
    hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol = Container.shared.hasBiometricAuthUseCase(),
    requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol = Container.shared.requestBiometricAuthUseCase(),
    allowBiometricUsageUseCase: AllowBiometricUsageUseCaseProtocol = Container.shared.allowBiometricUsageUseCase(),
    analytics: AnalyticsProtocol = Container.shared.analytics(),
    autoHideErrorDelay: Double = Container.shared.autoHideErrorDelay())
  {
    self.router = router
    self.getBiometricTypeUseCase = getBiometricTypeUseCase
    self.hasBiometricAuthUseCase = hasBiometricAuthUseCase
    self.requestBiometricAuthUseCase = requestBiometricAuthUseCase
    self.allowBiometricUsageUseCase = allowBiometricUsageUseCase
    self.analytics = analytics
    self.autoHideErrorDelay = autoHideErrorDelay

    biometricType = getBiometricTypeUseCase.execute()
    hasBiometricAuth = hasBiometricAuthUseCase.execute()

    configureObservers()
  }

  // MARK: Internal

  enum AnalyticsEvent: Error {
    case biometricRegistrationFailed
  }

  @Published var hasBiometricAuth = false
  var biometricType: BiometricType

  @Published var error: Error?
  @Published var isErrorPresented = false

  let autoHideErrorDelay: Double

  var primaryText: String {
    hasBiometricAuth ? L10n.tkOnboardingBiometricios1Title(biometricType.text) : L10n.tkOnboardingBiometricios3Title(biometricType.text)
  }

  var secondaryText: String {
    hasBiometricAuth ? L10n.tkOnboardingBiometricios1Body(biometricType.text) : L10n.tkOnboardingBiometricios3Body(biometricType.text)
  }

  var tertiaryText: String {
    hasBiometricAuth ? L10n.tkOnboardingBiometricios1Smallbody(biometricType.text) : L10n.tkOnboardingBiometricios3Smallbody(biometricType.text)
  }

  var image: Image {
    biometricType.image
  }

  func skip() {
    router.setup()
  }

  func registerBiometrics() async {
    do {
      try await requestBiometricAuthUseCase.execute(reason: L10n.onboardingBiometricPermissionReason, context: authContext)
      try allowBiometricUsageUseCase.execute(allow: true)

      router.setup()
    } catch {
      handleError(error)
      analytics.log(AnalyticsEvent.biometricRegistrationFailed)
    }
  }

  func openSettings() {
    router.settings()
  }

  func hideError() {
    isErrorPresented = false
  }

  // MARK: Private

  private let router: OnboardingInternalRoutes
  private let authContext: LAContextProtocol = Container.shared.authContext()
  private let analytics: AnalyticsProtocol

  private var hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol
  private var getBiometricTypeUseCase: GetBiometricTypeUseCaseProtocol
  private var requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol
  private var allowBiometricUsageUseCase: AllowBiometricUsageUseCaseProtocol

  private func configureObservers() {
    NotificationCenter.default.addObserver(forName: .willEnterForeground, object: nil, queue: .main) { [weak self] _ in
      Task { @MainActor [weak self] in
        self?.checkBiometricStatus()
      }
    }
  }

  private func checkBiometricStatus() {
    hasBiometricAuth = hasBiometricAuthUseCase.execute()
    biometricType = getBiometricTypeUseCase.execute()
  }

  private func handleError(_ error: Error) {
    self.error = error
    isErrorPresented = true
  }

}
