import BITCore
import BITCrypto
import Foundation

// MARK: - VcSdJwtError

enum VcSdJwtError: Error, Equatable {
  case keyNotFound(_ key: String)
}

// MARK: - VcSdJwt

/// https://www.ietf.org/archive/id/draft-ietf-oauth-sd-jwt-vc-04.html

public class VcSdJwt: SdJWT {

  // MARK: Lifecycle

  public init(from rawVcSdJwt: String, vcSdJwtDecoder: VcSdJwtDecoder = VcSdJwtDecoder()) throws {
    keyBinding = vcSdJwtDecoder.decodeKeyBinding(from: rawVcSdJwt)
    vct = vcSdJwtDecoder.decodeVct(from: rawVcSdJwt)
    statusList = vcSdJwtDecoder.decodeTokenStatusList(from: rawVcSdJwt)

    try super.init(from: rawVcSdJwt)

    // issuer is required for VcSdJwt but optional on JWT so we check here
    guard let vcIssuer = iss else {
      throw VcSdJwtError.keyNotFound("iss")
    }

    self.vcIssuer = vcIssuer
  }

  public convenience init(from rawVcSdJwt: String, rawDisclosures: String) throws {
    let sdJwt = try SdJWT(from: rawVcSdJwt, rawDisclosures: rawDisclosures)
    try self.init(from: sdJwt.raw)
  }

  // MARK: Public

  /// registered claims can be found [here](https://www.ietf.org/archive/id/draft-ietf-oauth-sd-jwt-vc-05.html#name-registered-jwt-claims)

  /// JWT `cnf`
  public let keyBinding: KeyBinding?

  /// JWT `vct`
  public let vct: String?

  public var vcIssuer: String = ""

  /// The information on how to read the status of the Verifiable Credential
  public var statusList: TokenStatusList?

  // MARK: Equatable

  public static func == (lhs: VcSdJwt, rhs: VcSdJwt) -> Bool {
    lhs as SdJWT == rhs as SdJWT && // Compare inherited properties
      lhs.keyBinding == rhs.keyBinding
  }
}

// MARK: VcSdJwt.KeyBinding

extension VcSdJwt {
  public struct KeyBinding: Equatable {
    public let jwk: PublicKeyInfo.JWK
  }
}
