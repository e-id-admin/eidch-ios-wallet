import Foundation
import JOSESwift

// MARK: - JWTDecoder

public struct JWTDecoder: JWTDecoderProtocol {

  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  public enum DecoderError: Error {
    case algorithmNotFound
  }

  public func decodeJWS(from rawJWT: String) throws -> JOSESwift.JWS {
    // take only the raw JWT in consideration in case the JWT contains additional parts such as disclosures for an SD-JWT
    let jwt = rawJWT.separatedByDisclosures.first.map(String.init) ?? rawJWT
    return try JOSESwift.JWS(compactSerialization: jwt)
  }

  public func decodeAlgorithm(from rawJWT: String) throws -> String {
    guard
      let jws = try? decodeJWS(from: rawJWT),
      let signatureAlgorithm = jws.header.algorithm
    else {
      throw DecoderError.algorithmNotFound
    }
    return signatureAlgorithm.rawValue
  }

  public func decodeType(from rawJWT: String) -> String? {
    try? decodeJWS(from: rawJWT).header.typ
  }

  public func decodeKid(from rawJWT: String) -> String? {
    try? decodeJWS(from: rawJWT).header.kid
  }

  public func decodePayload(from rawJWT: String) -> Data? {
    do {
      let jws = try decodeJWS(from: rawJWT)
      return jws.payload.data()
    } catch {
      return nil
    }
  }

  public func decodeTimestamp(from rawJWT: String, with key: String) -> Date? {
    guard
      let payload = decodePayload(from: rawJWT),
      let json = try? JSONSerialization.jsonObject(with: payload) as? [String: Any],
      let unixTimestamp = json[key] as? Double
    else { return nil }
    return Date(timeIntervalSince1970: unixTimestamp)
  }

  public func decodeStringField(from rawJWT: String, with key: String) -> String? {
    guard
      let payload = decodePayload(from: rawJWT),
      let json = try? JSONSerialization.jsonObject(with: payload) as? [String: Any],
      let field = json[key] as? String
    else { return nil }
    return field
  }
}

extension String {
  fileprivate static var disclosuresSeparator: Character { "~" }

  fileprivate var separatedByDisclosures: [SubSequence] {
    split(separator: Self.disclosuresSeparator)
  }
}
