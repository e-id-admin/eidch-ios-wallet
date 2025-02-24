import BITCrypto
import Factory
import Foundation
import JOSESwift
import Spyable

// MARK: - JWTHelperProtocol

@Spyable
public protocol JWTHelperProtocol {

  func hasValidSignature(jwt: JWT, using publicKey: SecKey) -> Bool
  func getSecKey(curve: String, x: String, y: String) throws -> SecKey?
  func jwt(with payload: Data, keyPair: KeyPair, type: String) throws -> JWT
}

// MARK: - JWTHelper

public struct JWTHelper: JWTHelperProtocol {

  // MARK: Public

  public func getSecKey(curve: String, x: String, y: String) throws -> SecKey? {
    try ECPublicKey.getSecKey(curve: curve, x: x, y: y)
  }

  public func hasValidSignature(jwt: JWT, using publicKey: SecKey) -> Bool {
    guard
      let jwtAlgorithm = JWTAlgorithm(rawValue: jwt.algorithm),
      let signatureAlgorithm = try? SignatureAlgorithm(from: jwtAlgorithm)
    else {
      return false
    }

    do {
      guard let verifier = Verifier(verifyingAlgorithm: signatureAlgorithm, key: publicKey) else { return false }
      let jws = try JWTDecoder().decodeJWS(from: jwt.raw)
      _ = try jws.validate(using: verifier).payload
      return true
    } catch {
      return false
    }
  }

  public func jwt(with payload: Data, keyPair: KeyPair, type: String) throws -> JWT {
    guard let jwtAlgorithm = JWTAlgorithm(rawValue: keyPair.algorithm) else {
      throw JWTHelperError.invalidAlgorithm
    }
    let signatureAlgorithm = try SignatureAlgorithm(from: jwtAlgorithm)
    let header: JWSHeader = try header(using: keyPair, algorithm: signatureAlgorithm, type: type)
    let jws = try sign(payload, with: header, using: signatureAlgorithm, keyPair: keyPair)
    return try JWT(from: jws.compactSerializedString)
  }

  // MARK: Private

  private func header(using keyPair: KeyPair, algorithm: SignatureAlgorithm, type: String) throws -> JWSHeader {
    guard let publicKey = keyPair.publicKey, let jwk = try? ECPublicKey(publicKey: publicKey) else {
      throw JWTHelperError.cannotCreateJwk
    }

    var parameters: [String: Any] = ["typ": type]
    parameters["jwk"] = jwk.parameters
    parameters[JWKParameter.algorithm.rawValue] = algorithm.rawValue
    return try JWSHeader(parameters: parameters)
  }

  private func sign(_ payloadData: Data, with header: JWSHeader, using algorithm: SignatureAlgorithm, keyPair: KeyPair) throws -> JWS {
    guard let signer = Signer(signingAlgorithm: algorithm, key: keyPair.privateKey) else {
      throw JWTHelperError.uninitializedSigner
    }
    let payload = Payload(payloadData)
    return try JWS(header: header, payload: payload, signer: signer)
  }

}

// MARK: - JWTHelperError

public enum JWTHelperError: Error, Equatable {
  case uninitializedSigner
  case invalidDid
  case invalidAlgorithm
  case cannotCreateJwk
}
