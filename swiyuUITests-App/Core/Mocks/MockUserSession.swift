import BITAppAuth
import BITLocalAuthentication
import LocalAuthentication

class MockUserSession: Session {

  var isLoggedIn = true
  var context: LAContextProtocol? = MockLAContext()

  func startSession(passphrase: Data, credentialType: LACredentialType) throws -> LAContextProtocol {
    MockLAContext()
  }

  func endSession() {}

}
