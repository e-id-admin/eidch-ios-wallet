import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - SplashScreenScene

@MainActor
final class SplashScreenScene: SceneManagerProtocol {

  // MARK: Internal

  weak var delegate: (any SceneManagerDelegate)?

  func viewController() -> UIViewController {
    let splashScreen = SplashScreenHostingController()
    splashScreen.delegate = self
    return splashScreen
  }

  // MARK: Private

  @AppStorage("rootOnboardingIsEnabled") private var isOnboardingEnabled = true

}

// MARK: SplashScreenDelegate

extension SplashScreenScene: SplashScreenDelegate {

  func didCompleteSplashScreen() {
    guard !isOnboardingEnabled else {
      delegate?.changeScene(to: OnboardingScene.self, animated: false)
      return
    }
    delegate?.changeScene(to: AppScene.self)
  }

}
