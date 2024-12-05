import BITTheming
import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - OnboardingModule

@MainActor
public class OnboardingModule {

  // MARK: Lifecycle

  public init(router: OnboardingRouter = Container.shared.onboardingRouter(), context: OnboardingContext = Container.shared.onboardingContext()) {
    self.router = router
    self.router.context = context

    let viewController = OnboardingNavigationController(rootViewController: UIHostingController(rootView: WelcomeIntroductionView(router: router)))
    viewController.navigationBar.prefersLargeTitles = false
    router.viewController = viewController

    self.viewController = viewController
  }

  // MARK: Public

  public let viewController: UIViewController
  public var router: OnboardingRouter

}
