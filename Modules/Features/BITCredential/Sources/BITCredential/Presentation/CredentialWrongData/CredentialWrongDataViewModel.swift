import Foundation

public class CredentialWrongDataViewModel: ObservableObject {

  // MARK: Lifecycle

  public init(router: CredentialWrongDataRouterRoutes) {
    self.router = router
  }

  // MARK: Internal

  func openInformations() {
    #warning("TODO: Define real URL")
    guard let supportUrl = URL(string: "https://www.eid.admin.ch/de/hilfe-support") else {
      return
    }

    router.openExternalLink(url: supportUrl)
  }

  func close() {
    router.close()
  }

  // MARK: Private

  private let router: CredentialWrongDataRouterRoutes
}
