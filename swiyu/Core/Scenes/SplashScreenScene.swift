import BITAppAuth
import BITSecurity
import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - SplashScreenScene

@MainActor
final class SplashScreenScene: SceneManagerProtocol {

  // MARK: Lifecycle

  init() {
    hasDevicePinUseCase = Container.shared.hasDevicePinUseCase()
    jailbreakDetector = Container.shared.jailbreakDetector()
  }

  init(hasDevicePinUseCase: HasDevicePinUseCaseProtocol = Container.shared.hasDevicePinUseCase(), jailbreakDetector: JailbreakDetectorProtocol = Container.shared.jailbreakDetector()) {
    self.hasDevicePinUseCase = hasDevicePinUseCase
    self.jailbreakDetector = jailbreakDetector
  }

  // MARK: Internal

  weak var delegate: (any SceneManagerDelegate)?

  func viewController() -> UIViewController {
    if #available(iOS 17.0, *) {
      let splashScreen = AnimatedSplashScreenHostingController()
      splashScreen.delegate = self
      return splashScreen
    } else {
      let splashScreen = SplashScreenHostingController()
      splashScreen.delegate = self
      return splashScreen
    }
  }

  // MARK: Private

  @AppStorage("rootOnboardingIsEnabled") private var isOnboardingEnabled: Bool = true

  private var hasDevicePinUseCase: HasDevicePinUseCaseProtocol
  private var jailbreakDetector: JailbreakDetectorProtocol

}

// MARK: SplashScreenDelegate

extension SplashScreenScene: SplashScreenDelegate {

  func didCompleteSplashScreen() {
    guard !jailbreakDetector.isDeviceJailbroken() else {
      delegate?.changeScene(to: JailbreakScene.self, animated: false)
      return
    }

    guard hasDevicePinUseCase.execute() else {
      delegate?.changeScene(to: NoDevicePinCodeScene.self, animated: false)
      return
    }

    guard !isOnboardingEnabled else {
      delegate?.changeScene(to: OnboardingScene.self, animated: false)
      return
    }

    delegate?.changeScene(to: AppScene.self)
  }

}
