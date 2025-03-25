import BITCredentialShared
import BITOpenID
import Factory
import SwiftUI

@MainActor
class CredentialOfferModule {

  // MARK: Lifecycle

  init(credential: Credential, trustStatement: TrustStatement?, router: CredentialOfferRouter = Container.shared.credentialOfferRouter()) {
    self.router = router
    let viewController = UIHostingController(rootView: CredentialOfferView(credential: credential, trustStatement: trustStatement, router: router))
    router.viewController = viewController

    self.viewController = viewController
  }

  // MARK: Internal

  let viewController: UIHostingController<CredentialOfferView>
  let router: CredentialOfferRouter
}
