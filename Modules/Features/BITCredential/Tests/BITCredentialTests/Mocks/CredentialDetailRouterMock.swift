import Foundation
@testable import BITCredential
@testable import BITNavigation
@testable import BITNavigationTestCore

class CredentialDetailRouterMock: ClosableRoutesMock, ExternalRoutes, CredentialDetailInternalRoutes {

  var didCallWrongData = false
  var didCallExternalLink = false

  func wrongData() {
    didCallWrongData = true
  }

  func openExternalLink(url: URL) {
    didCallExternalLink = true
  }
}
