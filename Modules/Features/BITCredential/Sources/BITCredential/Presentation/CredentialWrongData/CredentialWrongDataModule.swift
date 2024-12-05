import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - CredentialWrongDataModule

@MainActor
public class CredentialWrongDataModule {

  // MARK: Lifecycle

  init(router: CredentialWrongDataRouter = Container.shared.credentialWrongDataRouter()) {
    let router = router
    let viewController = UINavigationController(rootViewController: UIHostingController(rootView: CredentialWrongDataView(router: router)))
    router.viewController = viewController

    self.router = router
    self.viewController = viewController
  }

  // MARK: Public

  public let viewController: UIViewController
  public let router: CredentialWrongDataRouter

}
