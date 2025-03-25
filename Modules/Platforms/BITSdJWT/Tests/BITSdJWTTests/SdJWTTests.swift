import BITJWT
import Foundation
import XCTest
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore

final class SdJWTTests: XCTestCase {

  // MARK: Internal

  func testInit_fromRawStringPayload() throws {
    // swiftlint: disable all
    let rawString = String(data: SdJWT.Mock.sampleData, encoding: .utf8)!
    // swiftlint: enable all

    guard let sdJWT = try? SdJWT(from: rawString) else {
      XCTFail("init from rawString failed")
      return
    }

    XCTAssertEqual(sdJWT.raw, rawString)
  }

  func testApplySelectiveDisclosure_withFlatDisclosuresRequiringAllKeys_ReturnsWhole() throws {
    let sdJwt = SdJWT.Mock.flat
    let keys = [Self.key1, Self.key2, Self.key3]

    let newSdJwt = try sdJwt.applySelectiveDisclosure(for: keys)

    XCTAssertEqual(sdJwt, newSdJwt)
  }

  func testApplySelectiveDisclosure_withFlatDisclosuresRequiringSomeKeys_ReturnsJwtWithRequiredDisclosures() throws {
    let sdJwt = SdJWT.Mock.flat
    let keys = [Self.key1, Self.key3]

    let newSdJwt = try sdJwt.applySelectiveDisclosure(for: keys)

    let expected = [SdJWT.Mock.flatJwt, SdJWT.Mock.disclosure1, SdJWT.Mock.disclosure3, ""].joined(separator: SdJWT.disclosuresSeparator)
    XCTAssertEqual(expected, newSdJwt.raw)
  }

  func testApplySelectiveDisclosure_withFlatDisclosuresRequiringNoKeys_ReturnsJwt() throws {
    let sdJwt = SdJWT.Mock.flat
    let keys: [String] = []

    let newSdJwt = try sdJwt.applySelectiveDisclosure(for: keys)

    XCTAssertEqual(SdJWT.Mock.flatJwt + SdJWT.disclosuresSeparator, newSdJwt.raw)
  }

  func testApplySelectiveDisclosure_withFlatDisclosuresRequiringOtherKeys_ReturnsJwt() throws {
    let sdJwt = SdJWT.Mock.flat
    let keys: [String] = ["otherKey", "otherKey2"]

    let newSdJwt = try sdJwt.applySelectiveDisclosure(for: keys)

    XCTAssertEqual(SdJWT.Mock.flatJwt + SdJWT.disclosuresSeparator, newSdJwt.raw)
  }

  func testDecodeSample() throws {
    // swiftlint: disable all
    let rawString = String(data: SdJWT.Mock.sampleData, encoding: .utf8)!
    // swiftlint: enable all

    guard let sdJWT = try? SdJWT(from: rawString) else {
      XCTFail("init from rawCredential failed")
      return
    }

    XCTAssertFalse(sdJWT.raw.isEmpty)
    XCTAssertFalse(sdJWT.digests.isEmpty)
    XCTAssertEqual(16, sdJWT.disclosableClaims.count)
    XCTAssertEqual(16, sdJWT.digests.count)
    XCTAssertNotNil(sdJWT.issuedAt)
    XCTAssertNotNil(sdJWT.expiredAt)
    XCTAssertNotNil(sdJWT.activatedAt)
    XCTAssertNotNil(sdJWT.iss)
    XCTAssertTrue((sdJWT.iss?.isEmpty) == false)

    // swiftlint:disable all
    XCTAssertTrue(sdJWT.issuedAt! < sdJWT.expiredAt!)
    XCTAssertTrue(Date() < sdJWT.expiredAt!)

    XCTAssertTrue(sdJWT.activatedAt! < sdJWT.expiredAt!)
    XCTAssertTrue(Date() < sdJWT.expiredAt!)
    // swiftlint:enable all
  }

  func testDecodeSdJWT_noDigests() throws {
    // swiftlint: disable all
    let rawString = String(data: SdJWT.Mock.sampleNoDigests, encoding: .utf8)!
    // swiftlint: enable all
    XCTAssertThrowsError(try SdJWT(from: rawString)) { error in
      XCTAssertEqual(error as? SdJWTDecoder.SdJWTDecoderError, .keyNotFound("_sd"))
    }
  }

  func testDecodeSdJWT_digestNotFound() throws {
    // swiftlint: disable all
    let rawString = String(data: SdJWT.Mock.sampleDigestNotFound, encoding: .utf8)!
    // swiftlint: enable all
    XCTAssertThrowsError(try SdJWT(from: rawString)) { error in
      XCTAssertEqual(error as? SdJWTDecoder.SdJWTDecoderError, .digestNotFound)
    }
  }

  func testReplaceDigestsWithDisclosedClaims() throws {
    let sdJwt = SdJWT.Mock.sample
    let raw = try sdJwt.replaceDigestsWithDisclosedClaims()
    guard let data = raw.data(using: .utf8) else {
      XCTFail("error while decoding string created by replaceDigestsAndFindClaims")
      return
    }
    guard let payloadDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
      XCTFail("error while serialized the payload created in to a dictionary")
      return
    }
    XCTAssertNil(payloadDictionary["_sd"], "_sd key must have been removed")
    XCTAssertFalse(sdJwt.disclosableClaims.isEmpty)
    for claim in sdJwt.disclosableClaims {
      XCTAssertNotNil(payloadDictionary[claim.key] as? String, "claim with key \(claim.key) must have been added at the root of the VC")
    }
  }

  // MARK: Private

  private static let key1 = "test_key_1"
  private static let key2 = "test_key_2"
  private static let key3 = "test_key_3"

}
