import BITAnyCredentialFormat
import BITCrypto
import BITJWT
import BITLocalAuthentication
import BITSdJWT
import BITVault
import Factory
import Foundation

// MARK: - VcSdJwtVpTokenGenerator

struct VcSdJwtVpTokenGenerator: AnyVpTokenGeneratorProtocol {

  // MARK: Lifecycle

  init(
    sha256Hasher: Hashable = Container.shared.sha256Hasher(),
    jwtHelper: JWTHelperProtocol = Container.shared.jwtHelper())
  {
    self.jwtHelper = jwtHelper
    self.sha256Hasher = sha256Hasher
  }

  // MARK: Internal

  func generate(requestObject: RequestObject, credential: any AnyCredential, keyPair: KeyPair?, fields: [String]) throws -> VpToken {
    guard let originalVcSdJwt = credential as? VcSdJwt else {
      throw AnyVpTokenGeneratorError.invalidFormat
    }

    let disclosures = getRequiredDisclosures(from: originalVcSdJwt, considering: fields)

    let presentedVcSdJwt = try VcSdJwt(from: originalVcSdJwt.raw, rawDisclosures: disclosures)

    if let key = keyPair, let keyBindingJWT = generateKeyBindingJWT(from: presentedVcSdJwt, requestObject: requestObject, keyPair: key) {
      return Self.combine(vcSdJwt: presentedVcSdJwt, and: keyBindingJWT)
    }

    return presentedVcSdJwt.raw
  }

  // MARK: Private

  private let sha256Hasher: Hashable
  private let jwtHelper: JWTHelperProtocol
  private let bindingProofType = "kb+jwt"

  private static func combine(vcSdJwt: VcSdJwt, and keyBinding: JWT) -> VpToken {
    vcSdJwt.raw + keyBinding.raw
  }

  private func getRequiredDisclosures(from vcSdJwt: VcSdJwt, considering fields: [String]) -> String {
    let requiredDisclosures: [String] = fields.compactMap { claimKey in
      let anyClaim = vcSdJwt.claims.first(where: { $0.key == claimKey })
      guard let sdJwtClaim = anyClaim as? SdJWTClaim else {
        return nil
      }

      return sdJwtClaim.disclosure
    }

    return requiredDisclosures.joined(separator: String(SdJWT.disclosuresSeparator))
  }

  private func generateKeyBindingJWT(from vcSdJwt: VcSdJwt, requestObject: RequestObject, keyPair: KeyPair) -> JWT? {
    guard let sdJwtData = vcSdJwt.raw.data(using: .utf8) else {
      return nil
    }

    let sdJWTsha256 = sha256Hasher.hash(sdJwtData)
    let sdHash = sdJWTsha256.base64URLEncodedString()
    let keyBindingPayload = KeyBindingPayload(sdHash: sdHash, nonce: requestObject.nonce)

    do {
      let keyBindingPayloadData = try JSONEncoder().encode(keyBindingPayload)
      return try jwtHelper.jwt(with: keyBindingPayloadData, keyPair: keyPair, type: bindingProofType)
    } catch {
      return nil
    }
  }

}

// MARK: VcSdJwtVpTokenGenerator.KeyBindingPayload

extension VcSdJwtVpTokenGenerator {

  /// https://www.ietf.org/archive/id/draft-ietf-oauth-selective-disclosure-jwt-10.html
  fileprivate struct KeyBindingPayload: Codable, Equatable {
    private let sdHash: String
    private let audience: String
    private let nonce: String?
    private let issuedAt: Double

    fileprivate init(sdHash: String, audience: String = UUID().uuidString, nonce: String? = nil, issuedAt: Double = Date().timeIntervalSince1970) {
      self.sdHash = sdHash
      self.audience = audience
      self.nonce = nonce
      self.issuedAt = issuedAt
    }

    fileprivate enum CodingKeys: String, CodingKey {
      case audience = "aud"
      case nonce
      case issuedAt = "iat"
      case sdHash = "sd_hash"
    }
  }
}
