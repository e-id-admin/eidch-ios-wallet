import Foundation

class CredentialOfferWrongDataViewModel {

  // MARK: Lifecycle

  init(router: CredentialOfferInternalRoutes) {
    self.router = router
  }

  // MARK: Internal

  func close() {
    router.close()
  }

  // MARK: Private

  private let router: CredentialOfferInternalRoutes
}
