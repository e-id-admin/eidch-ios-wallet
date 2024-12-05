import Foundation
import LocalAuthentication

public class FakeLAContext: LAContext {
  override public func setCredential(_ credential: Data?, type: LACredentialType) -> Bool {
    true
  }
}
