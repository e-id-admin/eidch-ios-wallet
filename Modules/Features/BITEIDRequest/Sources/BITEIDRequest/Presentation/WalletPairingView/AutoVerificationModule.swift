import BITTheming
import Factory
import SwiftUI

@MainActor
class AutoVerificationModule {

  // MARK: Lifecycle

  init(router: EIDRequestRouter = Container.shared.eIDRequestRouter()) {
    self.router = router
    let viewController = UINavigationController(rootViewController: HideBackButtonHostingController(rootView: WalletPairingView(router: router)))
    router.viewController = viewController
    self.viewController = viewController
  }

  // MARK: Internal

  let viewController: UIViewController
  var router: EIDRequestRouter
}
