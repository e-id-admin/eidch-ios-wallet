import XCTest

@testable import BITJWT

// MARK: - JWTTests

final class JWTDecoderTests: XCTestCase {

  // MARK: Internal

  func testDecodeHeaderAlgorithm_success() throws {
    guard let rawString = String(data: JWT.Mock.sampleData, encoding: .utf8) else {
      fatalError("Could not create raw string from sample data")
    }

    let headerAlgorithm = try decoder.decodeAlgorithm(from: rawString)

    XCTAssertEqual(headerAlgorithm, "ES256")
  }

  func testDecodeHeaderAlgorithm_invalidAlgorithm() throws {
    guard let rawString = String(data: JWT.Mock.invalidAlgorithm, encoding: .utf8) else {
      fatalError("Could not create raw string from sample data")
    }

    XCTAssertThrowsError(try decoder.decodeAlgorithm(from: rawString)) { error in
      XCTAssertEqual(error as? JWTDecoder.DecoderError, .algorithmNotFound)
    }
  }

  func testDecodeType_success() throws {
    guard let rawString = String(data: JWT.Mock.sampleData, encoding: .utf8) else {
      fatalError("Could not create raw string from sample data")
    }

    let type = decoder.decodeType(from: rawString)

    XCTAssertEqual(type, "vc+sd-jwt")
  }

  func testDecodeType_noType() throws {
    guard let rawString = String(data: JWT.Mock.noTypeSample, encoding: .utf8) else {
      fatalError("Could not create raw string from sample data")
    }

    let type = decoder.decodeType(from: rawString)

    XCTAssertNil(type)
  }

  // MARK: Private

  private var decoder = JWTDecoder()

}
