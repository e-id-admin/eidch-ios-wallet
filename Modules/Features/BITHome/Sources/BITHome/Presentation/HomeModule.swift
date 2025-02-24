import BITNavigation
import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - HomeModule

@MainActor
public class HomeModule {

  // MARK: Lifecycle

  public init(router: Router<UIViewController> & HomeRouterRoutes = Container.shared.homeRouter()) {
    let viewModel = Container.shared.homeViewModel(router)
    let view = HomeComposerView(viewModel: viewModel)
      .environment(\.font, .custom.body)
      .preferredColorScheme(.light)
    let viewController = HomeHostingController(rootView: view)
    let navigation = UINavigationController(rootViewController: viewController)
    router.viewController = navigation

    self.viewController = navigation
    self.viewModel = viewModel
  }

  // MARK: Public

  public let viewController: UIViewController

  public let viewModel: HomeViewModel

}
