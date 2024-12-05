import BITCrypto
import Foundation
import Spyable

// MARK: - CredentialJWTGeneratorProtocol

/// Create a KeyPair and return the private key
@Spyable
protocol CredentialKeyPairGeneratorProtocol {
  func generate(identifier: UUID, algorithm: String) throws -> KeyPair
}
