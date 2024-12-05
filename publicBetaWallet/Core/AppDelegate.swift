import Alamofire
import BITAnalytics
import BITAppAuth
import BITCredential
import BITDataStore
import BITNetworking
import BITTheming
import Factory
import LocalAuthentication
import UIKit

// MARK: - AppDelegate

class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Internal

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool
  {
    BITAppearance.setup()

    configureUserDefaults()
    configureKeychain()
    configureSslPinning()
    configureAnalyticsIfAllowed()

    setupAdditionalConfigurationsIfNeeded()
    registerEnvironmentValues()

    return true
  }

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  // MARK: Private

  private let analytics = Container.shared.analytics()

}

extension AppDelegate {

  private func configureKeychain() {
    guard UserDefaults.standard.bool(forKey: "rootOnboardingIsEnabled") else { return }
    try? Container.shared.resetLoginAttemptCounterUseCase().execute()
    try? Container.shared.unlockWalletUseCase().execute()
  }

  private func configureUserDefaults() {
    UserDefaults.standard.register(defaults: [
      "rootOnboardingIsEnabled": true,
      "isBiometricUsageAllowed": false,
      "hasDeletedCredential": false,
    ])
  }

  private func configureSslPinning() {
    NetworkContainer.shared.serverTrustManager.register {
      BITServerTrustManager()
    }
  }

  private func configureAnalyticsIfAllowed() {
    let providers = [
      DynatraceProvider(),
    ]

    let analytics = Container.shared.analytics()
    for provider in providers {
      analytics.register(provider)
    }
  }
}
