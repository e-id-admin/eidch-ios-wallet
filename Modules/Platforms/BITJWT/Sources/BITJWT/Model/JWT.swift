import Foundation

// MARK: - JWT

/// https://www.rfc-editor.org/rfc/rfc7519.html

open class JWT: Equatable {

  // MARK: Lifecycle

  public init(from rawJWT: String, jwtDecoder: JWTDecoder = JWTDecoder()) throws {
    raw = rawJWT

    algorithm = try jwtDecoder.decodeAlgorithm(from: rawJWT)
    type = jwtDecoder.decodeType(from: rawJWT)
    kid = jwtDecoder.decodeKid(from: raw)

    iss = jwtDecoder.decodeStringField(from: rawJWT, with: "iss")
    subject = jwtDecoder.decodeStringField(from: rawJWT, with: "sub")
    audience = jwtDecoder.decodeStringField(from: rawJWT, with: "aud")

    expiredAt = jwtDecoder.decodeTimestamp(from: rawJWT, with: "exp")
    issuedAt = jwtDecoder.decodeTimestamp(from: rawJWT, with: "iat")
    activatedAt = jwtDecoder.decodeTimestamp(from: rawJWT, with: "nbf")
  }

  // MARK: Public

  /// The raw value of the JWT. e.g. "jwtHeader.jwtBody.jwtSignature"
  public let raw: String

  /// Header algorithm value aka `alg` in a JWSHeader
  public let algorithm: String

  /// Header type value aka `typ` in a JWSHeader
  public let type: String?

  /// The key ID is a hint indicating which key was used to secure the JWS
  public let kid: String?

  /// JWT `iss`
  public let iss: String?

  /// JWT `sub`
  public let subject: String?

  /// JWT `aud`
  public let audience: String?

  /// JWT `exp`
  public let expiredAt: Date?

  /// JWT `nbf`
  public let activatedAt: Date?

  /// JWT `iat`
  public let issuedAt: Date?

  // MARK: Equatable

  public static func == (lhs: JWT, rhs: JWT) -> Bool {
    lhs.raw == rhs.raw &&
      lhs.algorithm == rhs.algorithm &&
      lhs.type == rhs.type &&
      lhs.kid == rhs.kid &&
      lhs.iss == rhs.iss &&
      lhs.subject == rhs.subject &&
      lhs.audience == rhs.audience &&
      lhs.expiredAt == rhs.expiredAt &&
      lhs.activatedAt == rhs.activatedAt &&
      lhs.issuedAt == rhs.issuedAt
  }
}
