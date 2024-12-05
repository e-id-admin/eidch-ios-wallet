import BITAnyCredentialFormat
import BITCrypto
import Foundation
import Spyable

public typealias VpToken = String

// MARK: - AnyVpTokenGeneratorProtocol

@Spyable
public protocol AnyVpTokenGeneratorProtocol {
  func generate(requestObject: RequestObject, credential: any AnyCredential, keyPair: KeyPair?, fields: [String]) throws -> VpToken
}
