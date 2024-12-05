import BITCore
import Foundation
import JOSESwift
import XCTest

@testable import BITCrypto
@testable import BITJWT

final class JWTHelperTests: XCTestCase {

  // MARK: Internal

  func testInitWithPayloadData_JWTHelperVcJson_ShouldInitialize() throws {
    let payloadData = Data("Test Payload".utf8)
    let keyPair = try generateKeyPair()

    let jwt = try JWTHelper().jwt(with: payloadData, keyPair: keyPair, type: proofType)

    XCTAssertNotNil(jwt.raw)
    XCTAssertEqual(jwt.algorithm, SignatureAlgorithm.ES256.rawValue)
    XCTAssertEqual(3, jwt.raw.split(separator: ".").count)
  }

  func testInitWithPayloadData_DIDJWK_ShouldInitialize() throws {
    let payloadData = Data("Test Payload".utf8)
    let keyPair = try generateKeyPair()
    let didJwk = "did:jwk:example"

    let jwt = try JWTHelper().jwt(with: payloadData, keyPair: keyPair, type: proofType, didJwk: didJwk)

    XCTAssertNotNil(jwt.raw)
    XCTAssertEqual(jwt.algorithm, SignatureAlgorithm.ES256.rawValue)
    XCTAssertEqual(jwt.kid, didJwk)
    XCTAssertEqual(3, jwt.raw.split(separator: ".").count)
  }

  func testInitWithPayloadData_InvalidDIDJWK_ShouldThrowError() throws {
    let payloadData = Data("Test Payload".utf8)
    let keyPair = try generateKeyPair()
    let didJwk = "" // Invalid DID JWK

    XCTAssertThrowsError(try JWTHelper().jwt(with: payloadData, keyPair: keyPair, type: proofType, didJwk: didJwk)) { error in
      XCTAssertEqual(error as? JWTHelperError, .invalidDid)
    }
  }

  func testInitWithPayloadData_InvalidDIDJWKAlternative_ShouldThrowError() throws {
    let payloadData = Data("Test Payload".utf8)
    let keyPair = try generateKeyPair()
    let didJwk = "did:tdw:xyz" // Invalid DID JWK

    XCTAssertThrowsError(try JWTHelper().jwt(with: payloadData, keyPair: keyPair, type: proofType, didJwk: didJwk)) { error in
      XCTAssertEqual(error as? JWTHelperError, .invalidDid)
    }
  }

  func testHasValidSignature_InvalidAlgorithm_ShouldThrowError() throws {
    let payloadData = Data("Test Payload".utf8)
    let keyPair = try generateKeyPair(algorithm: "unknown")
    let didJwk = "did:jwk:example"

    XCTAssertThrowsError(try JWTHelper().jwt(with: payloadData, keyPair: keyPair, type: proofType, didJwk: didJwk)) { error in
      XCTAssertEqual(error as? JWTHelperError, .invalidAlgorithm)
    }
  }

  func testHasValidSignature_InvalidSignature_ShouldReturnFalse() throws {
    let payloadData = Data("Test Payload".utf8)
    let keyPair = try generateKeyPair()
    let anotherKeyPair = try generateKeyPair() // Different key pair to create an invalid signature
    let jwt = try JWTHelper().jwt(with: payloadData, keyPair: keyPair, type: proofType)

    guard let publicKey = anotherKeyPair.publicKey else {
      fatalError("Incorrect public key")
    }

    let isValid = JWTHelper().hasValidSignature(jwt: jwt, using: publicKey)

    XCTAssertFalse(isValid)
  }

  func testHasValidSignature_InvalidPublicKey_ShouldReturnFalse() throws {
    let payloadData = Data("Test Payload".utf8)
    let keyPair = try generateKeyPair()
    let jwt = try JWTHelper().jwt(with: payloadData, keyPair: keyPair, type: proofType)

    let anotherKeyPair: KeyPair = try generateKeyPair() // Use another key pair to simulate invalid public key

    guard let publicKey = anotherKeyPair.publicKey else {
      fatalError("Incorrect public key")
    }

    let isValid = JWTHelper().hasValidSignature(jwt: jwt, using: publicKey)

    XCTAssertFalse(isValid)
  }

  // MARK: Fileprivate

  fileprivate enum JWTHelperTestsError: Error {
    case keyGenerationFailed
  }

  // MARK: Private

  private let proofType = "openid4vci-proof+jwt"

  // MARK: - Helpers

  private func generateKeyPair(algorithm: String = "ES256") throws -> KeyPair {
    var publicKey, privateKey: SecKey?

    let keyPairAttr: [NSString: Any] = [
      kSecAttrKeyType: kSecAttrKeyTypeEC,
      kSecAttrKeySizeInBits: 256,
    ]

    let status = SecKeyGeneratePair(keyPairAttr as CFDictionary, &publicKey, &privateKey)

    guard status == errSecSuccess else { throw JWTHelperTestsError.keyGenerationFailed }
    // swiftlint: disable all
    return .init(identifier: UUID(), algorithm: algorithm, privateKey: privateKey!)
    // swiftlint: enable all
  }

}
