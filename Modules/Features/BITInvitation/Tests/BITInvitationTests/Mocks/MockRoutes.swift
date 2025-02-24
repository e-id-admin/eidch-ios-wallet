import BITCredentialShared
import BITInvitation
import BITOpenID
import Foundation
@testable import BITNavigationTestCore

final class MockRoutes: ClosableRoutesMock, CredentialOfferRouter.Routes {

  // MARK: Public

  public func credentialOffer(credential: Credential, trustStatement: TrustStatement?) {
    credentialOfferCalled = true
    credentialOfferCredential = credential
    self.trustStatement = trustStatement
  }

  // MARK: Internal

  private(set) var credentialOfferCalled = false
  private(set) var credentialOfferCredential: Credential?
  private(set) var trustStatement: TrustStatement?
  private(set) var wrongDataCalled = false

  func wrongData() {
    wrongDataCalled = true
  }

}
