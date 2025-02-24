import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - PresentationRequestResultStateModule

class PresentationRequestResultStateModule {

  // MARK: Lifecycle

  init(state: PresentationRequestResultState, context: PresentationRequestContext, router: PresentationRouter = Container.shared.presentationRouter()) {
    self.router = router

    let view = PresentationRequestResultStateView(state: state, context: context, router: router)

    let viewController = UIHostingController(rootView: view)
    router.viewController = viewController
    self.viewController = viewController
  }

  // MARK: Internal

  let viewController: UIViewController
  var router: PresentationRouter
}
