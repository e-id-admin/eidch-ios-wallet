import BITCredential
import Foundation

@testable import BITNavigationTestCore

class CredentialDetailRouterMock: ClosableRoutesMock, CredentialDetailRouterRoutes {

  var didCallWrongData = false

  func wrongData() {
    didCallWrongData = true
  }
}
