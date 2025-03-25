import BITCrypto
import BITJWT
import Foundation

// MARK: - VcSdJwtDecoder

public struct VcSdJwtDecoder: VcSdJwtDecoderProtocol {

  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  public func decodeKeyBinding(from rawVcSdJwt: String) -> VcSdJwt.KeyBinding? {
    guard
      let jwtPayload = JWTDecoder().decodePayload(from: rawVcSdJwt),
      let json = try? JSONSerialization.jsonObject(with: jwtPayload) as? [String: Any],
      let jwk = json[JsonKey.cnf.rawValue] as? [String: Any],
      let x = jwk["x"] as? String,
      let y = jwk["y"] as? String,
      let kty = jwk["kty"] as? String,
      let crv = jwk["crv"] as? String
    else {
      return nil
    }
    let kid = jwk["kid"] as? String

    return VcSdJwt.KeyBinding(jwk: PublicKeyInfo.JWK(kty: kty, kid: kid, crv: crv, x: x, y: y))
  }

  public func decodeVct(from rawVcSdJwt: String) -> (vct: String?, vctIntegrity: String?) {
    let vct = JWTDecoder().decodeStringField(from: rawVcSdJwt, with: JsonKey.vct.rawValue)
    let vctIntegrity = JWTDecoder().decodeStringField(from: rawVcSdJwt, with: JsonKey.vctIntegrity.rawValue)
    return (vct, vctIntegrity)
  }

  public func decodeTokenStatusList(from rawVcSdJwt: String) -> TokenStatusList? {
    guard
      let jwtPayload = JWTDecoder().decodePayload(from: rawVcSdJwt),
      let json = try? JSONSerialization.jsonObject(with: jwtPayload) as? [String: Any],
      let statusDictionary = json[JsonKey.status.rawValue] as? [String: Any],
      let data = try? JSONSerialization.data(withJSONObject: statusDictionary),
      let list = try? JSONDecoder().decode(TokenStatusList.self, from: data)
    else { return nil }
    return list
  }

  public func decodeNonDisclosableClaims(from rawVcSdJwt: String) -> [String: Any] {
    guard
      let jwtPayload = JWTDecoder().decodePayload(from: rawVcSdJwt),
      var claims = try? JSONSerialization.jsonObject(with: jwtPayload) as? [String: Any]
    else { return [:] }
    for claim in Self.reservedClaimNames {
      claims.removeValue(forKey: claim)
    }
    return claims
  }

  // MARK: Private

  private enum JsonKey: String {
    case cnf
    case vct
    case vctIntegrity = "vct#integrity"
    case status
  }

  private static let reservedClaimNames: Set<String> = [
    "iss", "sub", "aud", "exp", "iat", "nbf", "jti", // JWT
    "_sd_alg", "_sd", // SD-JWT
    "cnf", "vct", "status", "vct#integrity", // VcSdJwt
  ]
}
