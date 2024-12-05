import BITJWT
import Foundation
import Spyable

// MARK: - CredentialJWTGeneratorProtocol

@Spyable
protocol CredentialJWTGeneratorProtocol {
  func generate(credentialIssuer: String, didJwk: DidJwk, algorithm: String, privateKey: SecKey, nounce: String, type: String) throws -> JWT
}
