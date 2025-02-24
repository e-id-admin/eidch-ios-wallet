import BITL10n
import Foundation

@MainActor
class DataPrivacyViewModel {

  // MARK: Lifecycle

  init(router: EIDRequestInternalRoutes) {
    self.router = router
  }

  // MARK: Internal

  func openCheckCardIntroduction() {
    router.checkCardIntroduction()
  }

  func close() {
    router.close()
  }

  func openHelp() {
    guard let url = URL(string: L10n.tkGetEidDataPrivacyLinkValue) else {
      return
    }

    router.openExternalLink(url: url)
  }

  // MARK: Private

  private let router: EIDRequestInternalRoutes
}
