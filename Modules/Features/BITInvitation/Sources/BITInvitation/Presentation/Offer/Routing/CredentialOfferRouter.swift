import BITCredentialShared
import BITNavigation
import BITOpenID
import Factory
import SwiftUI

// MARK: - CredentialOfferRouter

final class CredentialOfferRouter: Router<UIViewController>, CredentialOfferInternalRoutes {}

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

extension CredentialOfferInternalRoutes where Self: RouterProtocol {

  func wrongData() {
    let viewController = UINavigationController(rootViewController: UIHostingController(rootView: CredentialOfferWrongDataView(router: self)))
    open(viewController, as: ModalOpeningStyle(animatedWhenPresenting: true))
  }
}
