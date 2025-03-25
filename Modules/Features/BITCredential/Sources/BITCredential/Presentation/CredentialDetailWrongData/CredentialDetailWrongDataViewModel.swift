import Foundation

class CredentialDetailWrongDataViewModel {

  // MARK: Lifecycle

  init(router: CredentialDetailInternalRoutes) {
    self.router = router
  }

  // MARK: Internal

  func close() {
    router.close()
  }

  // MARK: Private

  private let router: CredentialDetailInternalRoutes
}
