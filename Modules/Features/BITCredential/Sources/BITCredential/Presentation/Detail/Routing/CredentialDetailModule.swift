import BITCredentialShared
import Factory
import SwiftUI

@MainActor
public class CredentialDetailModule {

  // MARK: Lifecycle

  init(credential: Credential, router: CredentialDetailRouter = Container.shared.credentialDetailRouter()) {
    let router = router
    let viewController = UINavigationController(rootViewController: UIHostingController(rootView: CredentialDetailView(credential: credential, router: router)))
    router.viewController = viewController

    self.router = router
    self.viewController = viewController
  }

  // MARK: Internal

  let viewController: UIViewController
  let router: CredentialDetailRouter

}
