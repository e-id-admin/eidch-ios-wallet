import Factory
import Foundation
import SwiftUI
import UIKit

@MainActor
public class CameraPermissionModule {

  // MARK: Lifecycle

  public init(router: InvitationRouter = Container.shared.invitationRouter()) {
    self.router = router
    let viewController = UIHostingController(rootView: CameraPermissionView(router: router))
    router.viewController = viewController
    self.viewController = viewController
  }

  // MARK: Public

  public let viewController: UIViewController
  public var router: InvitationRouter
}
