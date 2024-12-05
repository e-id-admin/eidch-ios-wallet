import BITLocalAuthentication
import Factory
import Foundation
import LocalAuthentication

// MARK: - ContextManager

struct ContextManager: ContextManagerProtocol {

  init(credentialType: LACredentialType = Container.shared.authCredentialType()) {
    self.credentialType = credentialType
  }

  func setCredential(_ data: Data, context: LAContextProtocol) throws {
    guard context.setCredential(data, type: credentialType) else {
      throw AuthError.LAContextError(reason: "Error while trying to set the type \(credentialType) to the LAContext")
    }
  }

  private let credentialType: LACredentialType

}

// MARK: - SimulatorContextManager

#if targetEnvironment(simulator)
struct SimulatorContextManager: ContextManagerProtocol {
  func setCredential(_ data: Data, context: any LAContextProtocol) throws { }
}
#endif
