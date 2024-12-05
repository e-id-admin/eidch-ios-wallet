import BITCredential
import Foundation

@testable import BITNavigationTestCore

class CredentialWrongDataRouterMock: ClosableRoutesMock, CredentialWrongDataRouterRoutes {

  var didCallWrongData = false
  var didCallExternalLink = false

  func wrongData() {
    didCallWrongData = true
  }

  func openExternalLink(url: URL) {
    didCallExternalLink = true
  }
}
