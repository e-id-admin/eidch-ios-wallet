import BITCore
import Foundation
import JOSESwift
import XCTest
@testable import BITJWT

// MARK: - JWTTests

final class JWTTests: XCTestCase {

  func testInitWithRawString_ValidAlgorithmHeader_ShouldInitialize() throws {
    // swiftlint: disable all
    let rawString = String(data: JWT.Mock.sampleData, encoding: .utf8)!
    // swiftlint: enable all
    let jwt = try JWT(from: rawString)

    XCTAssertEqual(jwt.raw, rawString)
    XCTAssertNotNil(jwt.algorithm)
    XCTAssertNotNil(jwt.kid)
    XCTAssertNotNil(jwt.type)
  }

  func testInitWithRawString_InvalidAlgorithm_ShouldThrowError() {
    // swiftlint: disable all
    let rawString = String(data: JWT.Mock.invalidAlgorithm, encoding: .utf8)!
    // swiftlint: enable all

    XCTAssertThrowsError(try JWT(from: rawString)) { error in
      XCTAssertEqual(error as? JWTDecoder.DecoderError, .algorithmNotFound)
    }
  }

  func testAlgorithm() throws {
    let jwtWrapper = JWT.Mock.sample
    let algorithm = jwtWrapper.algorithm
    XCTAssertNotNil(algorithm)
    XCTAssertEqual("ES256", algorithm)
  }

  func testHeaderKid() throws {
    let jwtWrapper = JWT.Mock.sample
    let kid = jwtWrapper.kid
    XCTAssertNotNil(kid)
    XCTAssertEqual("did:tdw:example#key01", kid)
  }

}
