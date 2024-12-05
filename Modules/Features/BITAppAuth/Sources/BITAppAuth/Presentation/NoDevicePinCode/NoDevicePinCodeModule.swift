import Factory
import Foundation
import SwiftUI
import UIKit

@MainActor
public class NoDevicePinCodeModule {

  // MARK: Lifecycle

  public init(router: NoDevicePinCodeRouter = Container.shared.noDevicePinRouter()) {
    let router = router
    let viewModel = Container.shared.noDevicePinCodeViewModel(router)
    let view = NoDevicePinCodeView(viewModel: viewModel)
      .environment(\.font, .custom.body)
      .preferredColorScheme(.light)
    let viewController = UIHostingController(rootView: view)
    router.viewController = viewController

    self.router = router
    self.viewController = viewController
    self.viewModel = viewModel
  }

  // MARK: Public

  public let viewController: UIViewController
  public let viewModel: NoDevicePinCodeViewModel

  // MARK: Internal

  let router: NoDevicePinCodeRouter
}
