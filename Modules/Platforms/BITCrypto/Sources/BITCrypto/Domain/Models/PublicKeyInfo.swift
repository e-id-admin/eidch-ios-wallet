import Foundation

// MARK: - PublicKeyInfo

///  Defines the structure for public key information utilizing JSON Web Key Sets (JWKS)
///  as specified in RFC 7517 and RFC 8037. This struct provides a method to decode and
///  equate JWKS, facilitating cryptographic operations like signature validation.
///
/// - RFC 7517: https://www.rfc-editor.org/rfc/rfc7517.html
/// - RFC 8037: https://www.rfc-editor.org/rfc/rfc8037.html
public struct PublicKeyInfo: Decodable, Equatable {

  // MARK: Public

  public struct JWK: Decodable, Equatable {
    private let kty: String
    public let kid: String?
    public let crv: String
    public let x: String
    public let y: String

    public init(kty: String, kid: String?, crv: String, x: String, y: String) {
      self.kty = kty
      self.kid = kid
      self.crv = crv
      self.x = x
      self.y = y
    }
  }

  public let jwks: [JWK]

  // MARK: Fileprivate

  fileprivate enum CodingKeys: String, CodingKey {
    case jwks = "keys"
  }

}
