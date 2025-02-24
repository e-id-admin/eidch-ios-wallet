class IntroductionViewModel {

  // MARK: Lifecycle

  init(router: EIDRequestInternalRoutes) {
    self.router = router
  }

  // MARK: Internal

  func openDataPrivacy() {
    router.dataPrivacy()
  }

  func close() {
    router.close()
  }

  // MARK: Private

  private let router: EIDRequestInternalRoutes
}
