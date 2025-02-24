import BITCore
import BITCrypto
import Factory
import Foundation

// MARK: - VcSdJwtError

enum VcSdJwtError: Error, Equatable {
  case keyNotFound(_ key: String)
}

// MARK: - VcSdJwt

/// https://www.ietf.org/archive/id/draft-ietf-oauth-sd-jwt-vc-04.html

open class VcSdJwt: SdJWT {

  // MARK: Lifecycle

  public init(from rawVcSdJwt: String) throws {
    try super.init(from: rawVcSdJwt)

    keyBinding = vcSdJwtDecoder.decodeKeyBinding(from: rawVcSdJwt)
    vct = vcSdJwtDecoder.decodeVct(from: rawVcSdJwt)
    statusList = vcSdJwtDecoder.decodeTokenStatusList(from: rawVcSdJwt)

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
  public var keyBinding: KeyBinding?

  /// JWT `vct`
  public var vct: String?

  public var vcIssuer = ""

  /// The information on how to read the status of the Verifiable Credential
  public var statusList: TokenStatusList?

  // MARK: Equatable

  public static func == (lhs: VcSdJwt, rhs: VcSdJwt) -> Bool {
    lhs as SdJWT == rhs as SdJWT && // Compare inherited properties
      lhs.keyBinding == rhs.keyBinding
  }

  // MARK: Private

  @Injected(\.vcSdJwtDecoder) private var vcSdJwtDecoder: VcSdJwtDecoderProtocol
}

// MARK: VcSdJwt.KeyBinding

extension VcSdJwt {
  public struct KeyBinding: Equatable {
    public let jwk: PublicKeyInfo.JWK

    public init(jwk: PublicKeyInfo.JWK) {
      self.jwk = jwk
    }
  }
}
