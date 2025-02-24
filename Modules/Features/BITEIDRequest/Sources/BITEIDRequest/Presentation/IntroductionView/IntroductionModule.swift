import Factory
import SwiftUI

@MainActor
class IntroductionModule {

  // MARK: Lifecycle

  init(router: EIDRequestRouter = Container.shared.eIDRequestRouter()) {
    self.router = router
    let viewController = UINavigationController(rootViewController: UIHostingController(rootView: IntroductionView(router: router)))
    router.viewController = viewController
    self.viewController = viewController
  }

  // MARK: Internal

  let viewController: UIViewController
  var router: EIDRequestRouter
}
