import Foundation
import Spyable

// MARK: - JWTSignatureValidatorProtocol

@Spyable
public protocol JWTSignatureValidatorProtocol {
  func validate(_ jwt: JWT) async throws -> Bool
  func validate(_ jwt: JWT, from did: String) async throws -> Bool
}
