import Foundation

@MainActor
class QueueInformationViewViewModel {

  // MARK: Lifecycle

  init(router: EIDRequestInternalRoutes, onlineSessionStartDate: Date) {
    self.router = router
    expectedOnlineSessionStart = onlineSessionStartDate.formatted(date: .long, time: .omitted)
  }

  // MARK: Internal

  var expectedOnlineSessionStart: String?

  func primaryAction() {
    router.close()
  }

  // MARK: Private

  private let router: EIDRequestInternalRoutes
}
