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
      let crv = jwk["crv"] as? String,
      let kid = jwk["kid"] as? String
    else { return nil }

    return VcSdJwt.KeyBinding(jwk: PublicKeyInfo.JWK(kty: kty, kid: kid, crv: crv, x: x, y: y))
  }

  public func decodeVct(from rawVcSdJwt: String) -> String? {
    JWTDecoder().decodeStringField(from: rawVcSdJwt, with: JsonKey.vct.rawValue)
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

  // MARK: Private

  private enum JsonKey: String {
    case cnf
    case vct
    case status
  }
}
