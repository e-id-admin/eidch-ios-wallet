import Factory
import Foundation
import UIKit

@MainActor
public class LoginModule {

  // MARK: Lifecycle

  public init(router: LoginRouter = Container.shared.loginRouter()) {
    let router = router
    let viewModel = Container.shared.loginViewModel(router)
    let viewController = LoginHostingController(rootView: LoginView(viewModel: viewModel))
    let navigation = UINavigationController(rootViewController: viewController)
    router.viewController = navigation

    self.router = router
    self.viewController = navigation
    self.viewModel = viewModel
  }

  // MARK: Public

  public let viewController: UIViewController

  // MARK: Internal

  let router: LoginRouter
  let viewModel: LoginViewModel

}
