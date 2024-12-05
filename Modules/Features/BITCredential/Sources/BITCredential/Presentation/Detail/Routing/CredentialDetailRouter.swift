import BITCredentialShared
import BITNavigation
import Factory
import SwiftUI

// MARK: - CredentialDetailRoutes

public protocol CredentialDetailRoutes {
  func credentialDetail(_ credential: Credential)
}

@MainActor
extension CredentialDetailRoutes where Self: RouterProtocol {

  public func credentialDetail(_ credential: Credential) {
    let module = Container.shared.credentialDetailModule(credential)
    let style = ModalOpeningStyle(animated: true, modalPresentationStyle: .fullScreen)
    module.router.current = style

    let viewController = module.viewController
    open(viewController, on: self.viewController, as: style)
  }
}

// MARK: - CredentialDetailRouterRoutes

public protocol CredentialDetailRouterRoutes: ClosableRoutes & CredentialWrongDataRoutes {}

// MARK: - CredentialDetailRouter

public final class CredentialDetailRouter: Router<UIViewController>, CredentialDetailRouterRoutes { }
