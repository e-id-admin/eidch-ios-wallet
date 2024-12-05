import BITCredentialShared
import BITOpenID
import Factory
import SwiftUI

@MainActor
public class CredentialOfferModule {

  // MARK: Lifecycle

  public init(credential: Credential, trustStatement: TrustStatement?, router: CredentialOfferRouter = Container.shared.credentialOfferRouter()) {
    let router = router
    let viewModel = Container.shared.credentialOfferViewModel((credential, trustStatement, .result, router))
    let viewController = UIHostingController(rootView: CredentialOfferView(credential: credential, trustStatement: trustStatement, router: router))
    router.viewController = viewController

    self.router = router
    self.viewController = viewController
    self.viewModel = viewModel
  }

  // MARK: Internal

  let viewController: UIHostingController<CredentialOfferView>
  let router: CredentialOfferRouter

  // MARK: Private

  private let viewModel: CredentialOfferViewModel

}
