import BITCredentialShared
import BITInvitation
import BITNavigation
import BITOpenID
import BITPresentation
import Foundation

@testable import BITNavigationTestCore

class InvitationRouterMock: ClosableRoutesMock, InvitationRouterRoutes {

  var didCallCredentialOffer = false
  var didCallDeeplink = false
  var didCallInvitation = false
  var didCallCamera = false
  var didCallSettings = false
  var didCallExternalLink = false
  var didCallPresentationRequest = false
  var didCallCompatibleCredentials = false
  var didCallNextCompatibleCredentials = false
  var didCallPresentationReview = false
  var didCallWrongData = false

  func compatibleCredentials(for inputDescriptorId: String, and context: PresentationRequestContext) throws {
    didCallCompatibleCredentials = true
  }

  func presentationReview(with context: PresentationRequestContext) {
    didCallPresentationReview = true
  }

  func settings() {
    didCallSettings = true
  }

  func openExternalLink(url: URL) {
    didCallExternalLink = true
  }

  func camera(openingStyle: any OpeningStyle) {
    didCallCamera = true
  }

  func invitation() {
    didCallInvitation = true
  }

  func credentialOffer(credential: Credential, trustStatement: TrustStatement?) {
    didCallCredentialOffer = true
  }

  func deeplink(url: URL, animated: Bool) -> Bool {
    didCallDeeplink = true
    return true
  }

  func wrongData() {
    didCallWrongData = true
  }

}
