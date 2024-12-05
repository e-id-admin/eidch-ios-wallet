import Foundation
import Spyable

typealias DidJwk = String

// MARK: - CredentialDidJWKGeneratorProtocol

@Spyable
protocol CredentialDidJWKGeneratorProtocol {
  func generate(from metadataWrapper: CredentialMetadataWrapper, privateKey: SecKey) throws -> DidJwk
}
