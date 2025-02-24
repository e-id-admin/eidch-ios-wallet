import Foundation
@testable import BITAppAuth
@testable import BITNavigationTestCore

class BiometricChangeRouterRoutesMock: ClosableRoutesMock, BiometricChangeRouterRoutes {

  var loginCalled = false
  var biometicStatusUpdateCalled = false

  var delegate: (any BITAppAuth.BiometricChangeDelegate)?

  func login(animated: Bool) {
    loginCalled = true
  }

  func biometricStatusUpdate() {
    biometicStatusUpdateCalled = true
  }
}
