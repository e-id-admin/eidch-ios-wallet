import Factory
import SwiftUI

@MainActor
class CameraPermissionModule {

  // MARK: Lifecycle

  init(router: InvitationRouter = Container.shared.invitationRouter()) {
    self.router = router
    let viewController = UIHostingController(rootView: CameraPermissionView(router: router))
    router.viewController = viewController
    self.viewController = viewController
  }

  // MARK: Internal

  let viewController: UIViewController
  var router: InvitationRouter
}
