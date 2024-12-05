import BITCredentialShared
import BITHome
import BITNavigation
import Foundation

class HomeRouterMock: HomeRouterRoutes {

  var didCallDeeplink = false
  var didCallInvitation = false
  var didCallCamera = false
  var didCallSettings = false
  var didCallExternalLinkUrl = false
  var didCallOpenCredentialDetail = false

  func deeplink(url: URL, animated: Bool) -> Bool {
    didCallDeeplink = true
    return true
  }

  func invitation() {
    didCallInvitation = true
  }

  func camera(openingStyle: OpeningStyle) {
    didCallCamera = true
  }

  func settings() {
    didCallSettings = true
  }

  func openExternalLink(url: URL) {
    didCallExternalLinkUrl = true
  }

  func credentialDetail(_ credential: Credential) {
    didCallOpenCredentialDetail = true
  }

}
