import BITLocalAuthentication
import Foundation
import LocalAuthentication

struct MockLAContext: LAContextProtocol {
  var localizedReason = "mocked reason"
  var interactionNotAllowed = false
  var biometryType = LABiometryType.none

  func evaluatePolicy(_ policy: LAPolicy, localizedReason: String) async throws -> Bool {
    true
  }

  func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
    true
  }

  func setCredential(_ credential: Data?, type: LACredentialType) -> Bool {
    true
  }

  func isCredentialSet(_ type: LACredentialType) -> Bool {
    true
  }
}
