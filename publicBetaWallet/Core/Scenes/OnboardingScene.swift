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
    hasDevicePinUseCase = Container.shared.hasDevicePinUseCase()
    module.router.context.onboardingDelegate = self
  }

  init(
    hasDevicePinUseCase: HasDevicePinUseCaseProtocol = Container.shared.hasDevicePinUseCase())
  {
    self.hasDevicePinUseCase = hasDevicePinUseCase
    module.router.context.onboardingDelegate = self
  }

  // MARK: Internal

  weak var delegate: (any SceneManagerDelegate)?
  var module: OnboardingModule = Container.shared.onboardingModule()

  func viewController() -> UIViewController {
    module.viewController
  }

  func willEnterForeground() {
    guard hasDevicePinUseCase.execute() else {
      delegate?.changeScene(to: NoDevicePinCodeScene.self, animated: false)
      return
    }
  }

  // MARK: Private

  private var hasDevicePinUseCase: HasDevicePinUseCaseProtocol
}

// MARK: OnboardingDelegate

extension OnboardingScene: OnboardingDelegate {

  func didCompleteOnboarding() {
    delegate?.changeScene(to: AppScene.self)
    NotificationCenter.default.post(name: .didLogin, object: nil)
    NotificationCenter.default.post(name: .didLoginClose, object: nil)
  }

}
