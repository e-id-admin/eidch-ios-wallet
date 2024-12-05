import BITCore
import Foundation
import JOSESwift
import XCTest

@testable import BITCrypto
@testable import BITJWT

final class JWKHelperTests: XCTestCase {

  // MARK: Internal

  func testJWK_WithValidPublicKey_ShouldReturnJWKData() throws {
    let keyPair = try generateKeyPair()
    let jwkData = try JWKHelper().getJwkData(using: keyPair.publicKey, identifier: "identifier")

    XCTAssertNotNil(jwkData)
  }

  func testJWK_WithInvalidPublicKey_ShouldThrowError() throws {
    let publicKey = try generateInvalidPublicKey()

    do {
      _ = try JWKHelper().getJwkData(using: publicKey, identifier: "identifier")
    } catch JOSESwiftError.couldNotConstructJWK {
      return
    } catch {
      XCTFail("Unexpected error type thrown: \(error)")
    }
  }

  // MARK: Fileprivate

  // MARK: - Errors

  fileprivate enum JWKHelperTestsError: Error {
    case keyGenerationFailed
    case keyRetrievalFailed
  }

  // MARK: Private

  // MARK: - Helpers

  private func generateKeyPair() throws -> SymetricKeyPair {
    let keyPairAttr: [NSString: Any] = [
      kSecAttrKeyType: kSecAttrKeyTypeEC,
      kSecAttrKeySizeInBits: 256,
      kSecPrivateKeyAttrs: [
        kSecAttrIsPermanent: false,
      ],
    ]

    var error: Unmanaged<CFError>?
    guard let privateKey = SecKeyCreateRandomKey(keyPairAttr as CFDictionary, &error) else {
      // swiftlint: disable all
      throw (error?.takeRetainedValue() as? Error)!
      // swiftlint: enable all
    }

    guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
      throw JWKHelperTestsError.keyRetrievalFailed
    }

    return .init(privateKey: privateKey, publicKey: publicKey)
  }

  private func generateInvalidPublicKey() throws -> SecKey {
    let keyPairAttr: [NSString: Any] = [
      kSecAttrKeyType: kSecAttrKeyTypeRSA,
      kSecAttrKeySizeInBits: 1024,
      kSecPrivateKeyAttrs: [
        kSecAttrIsPermanent: false,
      ],
    ]

    var error: Unmanaged<CFError>?
    guard let privateKey = SecKeyCreateRandomKey(keyPairAttr as CFDictionary, &error) else {
      // swiftlint: disable all
      throw error!.takeRetainedValue() as Error
      // swiftlint: enable all
    }

    guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
      throw JWKHelperTestsError.keyRetrievalFailed
    }

    return publicKey
  }
}
