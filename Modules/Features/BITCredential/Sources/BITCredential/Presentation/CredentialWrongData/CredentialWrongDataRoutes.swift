import BITNavigation
import Factory
import Foundation
import UIKit

// MARK: - CredentialWrongDataRoutes

public protocol CredentialWrongDataRoutes {
  func wrongData()
}

@MainActor
extension CredentialWrongDataRoutes where Self: RouterProtocol {

  public func wrongData() {
    let module = Container.shared.credentialWrongDataModule()
    let style = ModalOpeningStyle(animatedWhenPresenting: true)
    module.router.current = style

    let viewController = module.viewController
    open(viewController, on: self.viewController, as: style)
  }
}

// MARK: - CredentialWrongDataRouterRoutes

public protocol CredentialWrongDataRouterRoutes: ClosableRoutes, CredentialWrongDataRoutes, ExternalRoutes {}

// MARK: - CredentialWrongDataRouter

final public class CredentialWrongDataRouter: Router<UIViewController>, CredentialWrongDataRouterRoutes {}
