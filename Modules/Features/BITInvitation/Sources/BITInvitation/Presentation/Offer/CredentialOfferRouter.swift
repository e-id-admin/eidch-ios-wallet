import BITCredential
import BITCredentialShared
import BITNavigation
import BITOpenID
import Factory
import SwiftUI
import UIKit

// MARK: - CredentialOfferRoutes

public protocol CredentialOfferRoutes {
  func credentialOffer(credential: Credential, trustStatement: TrustStatement?)
}

@MainActor
extension CredentialOfferRoutes where Self: RouterProtocol {

  public func credentialOffer(credential: Credential, trustStatement: TrustStatement?) {
    let module = Container.shared.credentialOfferModule((credential, trustStatement: trustStatement))
    let style = NavigationPushOpeningStyle()
    module.router.current = style

    let viewController = module.viewController
    open(viewController, on: self.viewController, as: style)
  }
}

// MARK: - CredentialOfferRouterRoutes

public protocol CredentialOfferRouterRoutes: CredentialOfferRoutes & ClosableRoutes & CredentialWrongDataRoutes {}

// MARK: - CredentialOfferRouter

final public class CredentialOfferRouter: Router<UIViewController>, CredentialOfferRouterRoutes {
  public typealias Routes = CredentialOfferRouterRoutes
}
