import BITJWT
import Foundation
import JOSESwift

// MARK: - SdJWTDecoder

public struct SdJWTDecoder: SdJWTDecoderProtocol {

  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  public func decodeDigests(from rawString: String) throws -> [SdJwtDigest] {
    let jws: JWS = try getJws(from: rawString)
    return try findSelectiveDisclosures(in: jws.payload.data())
  }

  public func decodeClaims(from rawString: String, digests: [SdJwtDigest]) throws -> [SdJWTClaim] {
    let sdJWTParts = rawString.separatedByDisclosures.map(String.init)
    let claims = try sdJWTParts[1...]
      .compactMap { disclosure -> SdJWTClaim? in
        guard
          let rawDisclosableClaim = disclosure.base64Decoded,
          let disclosableClaim = try? rawDisclosableClaim.toJsonObject() as? [Any]
        else { return nil }

        let jws = try getJws(from: rawString)
        let algo = try findAlgorithm(in: jws.payload.data())
        guard let digest = try findDigest(for: disclosure, in: digests, algorithm: algo) else {
          throw SdJWTDecoderError.digestNotFound
        }
        return try SdJWTClaim(
          disclosableClaim: disclosableClaim,
          disclosure: disclosure,
          digest: digest)
      }
    return claims
  }

  // MARK: Internal

  enum SdJWTDecoderError: Error, Equatable {
    case keyNotFound(_ key: String)
    case invalidRawSdJwt
    case digestNotFound
  }

  // MARK: Private

  private enum JsonKey: String {
    case sd = "_sd"
  }
}

// MARK: Utils

extension SdJWTDecoder {

  private func getJws(from rawCredential: String) throws -> JWS {
    guard
      let rawJwt = rawCredential.separatedByDisclosures.map(String.init).first
    else { throw SdJWTDecoderError.invalidRawSdJwt }
    return try JWS(compactSerialization: rawJwt)
  }

  private func findSelectiveDisclosures(in jwtPayloadData: Data) throws -> [SdJwtDigest] {
    guard
      let json = try JSONSerialization.jsonObject(with: jwtPayloadData) as? [String: Any],
      let sdValues = json[JsonKey.sd.rawValue] as? [SdJwtDigest]
    else {
      throw SdJWTDecoderError.keyNotFound(JsonKey.sd.rawValue)
    }
    return sdValues
  }

  private func findAlgorithm(in jwtPayloadData: Data, defaultAlgorithm: StringDigest.Algorithm = .sha256) throws -> StringDigest.Algorithm {
    guard
      let json = try JSONSerialization.jsonObject(with: jwtPayloadData) as? [String: Any],
      let stringAlgorithm = json["_sd_alg"] as? String
    else { return defaultAlgorithm }
    return StringDigest.Algorithm(rawValue: stringAlgorithm) ?? defaultAlgorithm
  }

  private func findDigest(for disclosure: String, in digests: [SdJwtDigest], algorithm: StringDigest.Algorithm) throws -> SdJwtDigest? {
    let actualDigest = try disclosure.digest(algorithm: algorithm)
    guard
      let digest = digests.first(where: { $0 == actualDigest })
    else {
      return nil
    }
    return digest
  }

}
