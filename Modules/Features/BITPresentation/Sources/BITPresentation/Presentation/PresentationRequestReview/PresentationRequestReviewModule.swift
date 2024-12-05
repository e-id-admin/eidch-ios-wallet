import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - PresentationRequestReviewModule

public class PresentationRequestReviewModule {

  // MARK: Lifecycle

  public init(context: PresentationRequestContext, router: PresentationRouter = Container.shared.presentationRouter()) {
    self.router = router

    let view = PresentationRequestReviewView(context: context, router: router)

    let viewController = UIHostingController(rootView: view)
    router.viewController = viewController
    self.viewController = viewController
  }

  // MARK: Public

  public let viewController: UIViewController
  public var router: PresentationRouter
}
