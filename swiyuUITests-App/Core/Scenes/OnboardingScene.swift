import BITAppAuth
import BITOnboarding
import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - OnboardingScene

@MainActor
final class OnboardingScene: SceneManagerProtocol {

  // MARK: Lifecycle

  init() {
    module.router.context.onboardingDelegate = self
  }

  // MARK: Internal

  weak var delegate: (any SceneManagerDelegate)?
  var module: OnboardingModule = Container.shared.onboardingModule()

  func viewController() -> UIViewController {
    module.viewController
  }
}

// MARK: OnboardingDelegate

extension OnboardingScene: OnboardingDelegate {

  func didCompleteOnboarding() {
    delegate?.changeScene(to: AppScene.self)
    NotificationCenter.default.post(name: .didLogin, object: nil)
    NotificationCenter.default.post(name: .didLoginClose, object: nil)
  }

}
