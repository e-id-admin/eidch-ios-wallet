import Factory
import Foundation
import XCTest
@testable import BITJWT
@testable import BITOpenID

// MARK: - TokenStatusListDecoderTests

final class TokenStatusListDecoderTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyTokenStatusListByteDecoder = TokenStatusListByteDecoderProtocolSpy()
    Container.shared.tokenStatusListByteDecoder.register { self.spyTokenStatusListByteDecoder }

    spyJWTDecoder = JWTDecoderProtocolSpy()
    Container.shared.jwtDecoder.register { self.spyJWTDecoder }

    decoder = TokenStatusListDecoder()
  }

  func testDecode_ValidJWT_ShouldReturnStatusCode() async throws {
    let mockData = JWT.Mock.tokenStatusList
    let index = 1
    let statusCode = StatusCode(0)
    spyTokenStatusListByteDecoder.decodeBitsIndexReturnValue = statusCode
    spyJWTDecoder.decodePayloadFromReturnValue = JWT.Mock.tokenStatusListPayload

    let result = try decoder.decode(mockData, index: index)

    XCTAssertEqual(result, statusCode)
    XCTAssertEqual(mockData, spyJWTDecoder.decodePayloadFromReceivedRawJWT)
    XCTAssertEqual(2, spyTokenStatusListByteDecoder.decodeBitsIndexReceivedArguments?.bits)
    XCTAssertEqual(index, spyTokenStatusListByteDecoder.decodeBitsIndexReceivedArguments?.index)
    XCTAssertEqual(Data(fromArray: BYTES), spyTokenStatusListByteDecoder.decodeBitsIndexReceivedArguments?.statusList)
  }

  func testDecode_InvalidJWT_ShouldThrowError() async throws {
    spyJWTDecoder.decodePayloadFromReturnValue = nil

    XCTAssertThrowsError(try decoder.decode(JWT.Mock.tokenStatusList, index: 0)) { error in
      XCTAssertEqual(error as? TokenStatusListDecoder.DecoderError, .invalidStatusJWT)
    }

    XCTAssertTrue(spyJWTDecoder.decodePayloadFromCalled)
    XCTAssertFalse(spyTokenStatusListByteDecoder.decodeBitsIndexCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var decoder: TokenStatusListDecoder!
  private var spyTokenStatusListByteDecoder: TokenStatusListByteDecoderProtocolSpy!
  private var spyJWTDecoder: JWTDecoderProtocolSpy!
  // swiftlint:enable all
  private let BYTES = [0xC9, 0x44, 0xF9] as [UInt8] // "110010010100010011111001"
}

extension Data {
  fileprivate init(fromArray values: [some Any]) {
    self = values.withUnsafeBytes { Data($0) }
  }
}
