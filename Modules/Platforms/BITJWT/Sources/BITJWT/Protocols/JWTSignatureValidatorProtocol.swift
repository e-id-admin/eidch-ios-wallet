import Foundation
import Spyable

// MARK: - JWTSignatureValidatorProtocol

@Spyable
public protocol JWTSignatureValidatorProtocol {
  func validate(_ jwt: JWT, did: String, kid: String) async throws -> Bool
}
