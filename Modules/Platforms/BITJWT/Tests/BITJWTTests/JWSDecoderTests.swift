import Foundation
import JOSESwift
import XCTest
@testable import BITJWT

// MARK: - JWSDecoderTests

// swiftlint: disable force_unwrapping

final class JWSDecoderTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    decoder = JWSDecoder()
  }

  func testDecode_ValidJWS_ReturnsJWS() throws {
    let data = JWTRegisteredPayload.Mock.sampleData

    let jws = try decoder.decode(JWTRegisteredPayload.self, from: data)

    XCTAssertEqual(jws.payload, JWTRegisteredPayload.Mock.registeredPayload)
    XCTAssertEqual(jws.algorithm, "ES512")
    XCTAssertEqual(jws.type, "jwt")
    XCTAssertEqual(jws.keyIdentifier, "keyIdentifier")
    XCTAssertEqual(jws.jwk, JWTRegisteredPayload.Mock.jwk)
  }

  func testDecode_ValidJWSWithIsoDate_ReturnsJWS() throws {
    let data = JWTRegisteredPayload.Mock.sampleIsoDate
    decoder.dateDecodingStrategy = .iso8601

    let jws = try decoder.decode(TestDatePayload.self, from: data)

    XCTAssertEqual(jws.payload, TestDatePayload(date: Date(timeIntervalSinceReferenceDate: 0)))
    XCTAssertEqual(jws.algorithm, "ES512")
    XCTAssertEqual(jws.type, "test")
    XCTAssertNil(jws.keyIdentifier)
    XCTAssertNil(jws.jwk)
  }

  func testDecode_InvalidJWS_ThrowsError() throws {
    let data = "invalid".data(using: .utf8)!

    XCTAssertThrowsError(try decoder.decode(JWTRegisteredPayload.self, from: data)) { error in
      XCTAssertTrue(error is JOSESwiftError)
    }
  }

  func testDecode_NoneAlgorithm_ThrowsError() throws {
    let data = JWTRegisteredPayload.Mock.noneAlgorithmData

    XCTAssertThrowsError(try decoder.decode(JWTRegisteredPayload.self, from: data)) { error in
      XCTAssertTrue(error is JOSESwiftError)
    }
  }

  func testDecode_InvalidAlgorithm_ThrowsError() throws {
    let data = JWTRegisteredPayload.Mock.invalidAlgorithmData

    XCTAssertThrowsError(try decoder.decode(JWTRegisteredPayload.self, from: data)) { error in
      XCTAssertEqual(error as? JWSDecoderError, .algorithmNotFound)
    }
  }

  func testDecode_InvalidType_ThrowsError() throws {
    let data = JWTRegisteredPayload.Mock.invalidTypeData

    XCTAssertThrowsError(try decoder.decode(JWTRegisteredPayload.self, from: data)) { error in
      XCTAssertEqual(error as? JWSDecoderError, .invalidType)
    }
  }

  // MARK: Private

  private var decoder = JWSDecoder()

}

// MARK: - TestDatePayload

private struct TestDatePayload: JWTType & Codable & Equatable {

  let type = "test"
  private let date: Date

  init(date: Date) {
    self.date = date
  }

  enum CodingKeys: String, CodingKey {
    case date
  }

}

// swiftlint: enable force_unwrapping
