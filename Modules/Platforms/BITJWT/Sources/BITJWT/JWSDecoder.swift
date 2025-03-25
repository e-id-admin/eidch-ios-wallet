import BITCrypto
import Foundation
import JOSESwift

// MARK: - JWSDecoderError

public enum JWSDecoderError: Error {
  case invalidType
  case algorithmNotFound
}

// MARK: - JWSDecoder

public struct JWSDecoder: JWSDecoderProtocol {

  // MARK: Lifecycle

  public init(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970) {
    self.dateDecodingStrategy = dateDecodingStrategy
  }

  // MARK: Public

  public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy

  public func decode<T>(_ type: T.Type, from data: Data) throws -> JWS<T> where T: JWTType & Decodable {
    let jws = try JOSESwift.JWS(compactSerialization: data)
    let payload: T = try decodePayload(from: jws.payload.data())
    return try createJWT(from: jws, payload: payload)
  }

  // MARK: Private

  private func decodePayload<T>(from data: Data) throws -> T where T: Decodable {
    let decoder = JSONDecoder(dateDecodingStrategy: dateDecodingStrategy)
    return try decoder.decode(T.self, from: data)
  }

  private func createJWT<T>(from jws: JOSESwift.JWS, payload: T) throws -> JWS<T> {
    guard let algorithm = jws.header.algorithm else { throw JWSDecoderError.algorithmNotFound }
    guard let headerType = jws.header.typ, headerType == payload.type else { throw JWSDecoderError.invalidType }
    return try JWS(
      payload: payload,
      algorithm: algorithm.rawValue,
      type: headerType,
      keyIdentifier: jws.header.kid,
      jwk: jws.header.publicJwk())
  }
}

extension JWSHeader {
  fileprivate func publicJwk() throws -> PublicKeyInfo.JWK? {
    if let jwkData = jwkTyped?.jsonData() {
      try JSONDecoder().decode(PublicKeyInfo.JWK.self, from: jwkData)
    } else {
      nil
    }
  }
}
