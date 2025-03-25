import BITAppAuth
@testable import BITNavigationTestCore

class NoDevicePinCodeRouterMock: ClosableRoutesMock, NoDevicePinCodeRouterRoutes {
  var didCallAppSettings = false

  func settings() {
    didCallAppSettings = true
  }
}
