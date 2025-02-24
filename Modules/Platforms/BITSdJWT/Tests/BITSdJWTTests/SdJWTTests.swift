import BITJWT
import Foundation
import XCTest
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore

final class SdJWTTests: XCTestCase {

  func testInit_fromRawStringPayload() throws {
    // swiftlint: disable all
    let rawString = String(data: SdJWT.Mock.sampleData, encoding: .utf8)!
    // swiftlint: enable all

    guard let sdJWT = try? SdJWT(from: rawString) else {
      XCTFail("init from rawCredential failed")
      return
    }

    XCTAssertEqual(sdJWT.raw, rawString)
  }

  func testInit_withDisclosures() throws {
    // swiftlint: disable all
    let rawString = String(data: SdJWT.Mock.sampleData, encoding: .utf8)!
    // swiftlint: enable all
    let parts = rawString.split(separator: SdJWT.disclosuresSeparator)
    let disclosures = parts[1..<parts.count]
    let rawDisclosures = disclosures.joined(separator: String(SdJWT.disclosuresSeparator))

    guard let sdJwt = try? SdJWT(from: rawString, rawDisclosures: rawDisclosures) else {
      XCTFail("init with disclosures failed")
      return
    }

    XCTAssertEqual(rawString, sdJwt.raw)
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

  func testReplaceDigestsAndFindClaims() throws {
    let sdJwt = SdJWT.Mock.sample
    let raw = try sdJwt.replaceDigestsAndFindClaims()
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

}
