import BITL10n
import Foundation
import SwiftUI

@MainActor
class BetaIdViewModel: ObservableObject {

  // MARK: Lifecycle

  init(router: InvitationRouterRoutes) {
    self.router = router
  }

  // MARK: Internal

  func openBetaIdLink() {
    guard let url = URL(string: L10n.tkGlobalBetaidUrl) else {
      return
    }

    router.openExternalLink(url: url) {
      self.router.close()
    }
  }

  // MARK: Private

  private var router: InvitationRouterRoutes
}
