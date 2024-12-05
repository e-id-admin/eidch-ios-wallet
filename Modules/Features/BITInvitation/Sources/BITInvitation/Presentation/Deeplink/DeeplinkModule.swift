import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - CameraModule

@MainActor
public class DeeplinkModule {

  // MARK: Lifecycle

  public init(url: URL, router: InvitationRouter = Container.shared.invitationRouter()) {
    self.router = router
    let viewController = UIHostingController(rootView: DeeplinkLoadingView(url: url, router: router))
    router.viewController = viewController
    self.viewController = viewController
  }

  // MARK: Public

  public let viewController: UIViewController
  public var router: InvitationRouter
}
