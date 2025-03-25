import BITCrypto
import Foundation

// MARK: - JWTType

public protocol JWTType {
  var type: String { get }
}

// MARK: - JWS

/// This class represents a signed JWT which is specified by https://www.rfc-editor.org/rfc/rfc7519.html
/// The payload is generic and can consist of registered, public and private claims (see specifications for more details).

open class JWS<T: JWTType & Codable & Equatable>: Equatable {

  // MARK: Lifecycle

  public init(
    payload: T,
    algorithm: String,
    type: String? = nil,
    keyIdentifier: String? = nil,
    jwk: PublicKeyInfo.JWK? = nil) throws
  {
    self.payload = payload
    self.algorithm = algorithm
    self.type = type
    self.keyIdentifier = keyIdentifier
    self.jwk = jwk
  }

  // MARK: Public

  /// Payload that consists of registered, public and private claims
  public let payload: T

  /// Header algorithm value aka `alg` in a JWSHeader
  public let algorithm: String

  /// Header type value aka `typ` in a JWSHeader
  public let type: String?

  /// The key ID is a hint indicating which key was used to secure the JWS
  public let keyIdentifier: String?

  /// The key info
  public let jwk: PublicKeyInfo.JWK?

  // MARK: Equatable

  public static func == (lhs: JWS<T>, rhs: JWS<T>) -> Bool {
    lhs.payload == rhs.payload &&
      lhs.algorithm == rhs.algorithm &&
      lhs.type == rhs.type &&
      lhs.keyIdentifier == rhs.keyIdentifier &&
      lhs.jwk == rhs.jwk
  }
}
