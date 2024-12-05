import Factory
import XCTest

@testable import BITCrypto
@testable import BITJWT
@testable import BITTestingCore

final class JWTSignatureValidatorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    jwtHelper = JWTHelperProtocolSpy()
    spyDidResolver = DidResolverHelperProtocolSpy()

    Container.shared.jwtHelper.register {
      self.jwtHelper
    }

    Container.shared.didResolverHelper.register {
      self.spyDidResolver
    }

    validator = JWTSignatureValidator()
  }

  func testValidate_WithOneValidPublicKey_ShouldReturnTrue() async throws {
    spyDidResolver.getJWKSFromReturnValue = [.Mock.validSample]
    let mockSecKey = SecKeyTestsHelper.createPrivateKey()
    jwtHelper.getSecKeyCurveXYReturnValue = mockSecKey
    jwtHelper.hasValidSignatureJwtUsingReturnValue = true

    let result = try await validator.validate(.Mock.sample, from: issuer)

    XCTAssertTrue(result)
    XCTAssertEqual(JWT.Mock.sample.raw, jwtHelper.hasValidSignatureJwtUsingReceivedArguments?.jwt.raw)
    XCTAssertEqual(mockSecKey, jwtHelper.hasValidSignatureJwtUsingReceivedArguments?.publicKey)
  }

  func testValidate_WithMultipleJWKsOneValid_ShouldReturnTrue() async throws {
    spyDidResolver.getJWKSFromReturnValue = [.Mock.invalidSample, .Mock.invalidSample, .Mock.validSample]

    var hasValidSignatureJwtCount = 0
    jwtHelper.getSecKeyCurveXYReturnValue = SecKeyTestsHelper.createPrivateKey()
    jwtHelper.hasValidSignatureJwtUsingClosure = { _, _ in
      if hasValidSignatureJwtCount < 2 {
        hasValidSignatureJwtCount += 1
        return false
      } else {
        return true
      }
    }

    let result = try await validator.validate(.Mock.sample, from: issuer)

    XCTAssertTrue(spyDidResolver.getJWKSFromCalled)
    XCTAssertTrue(jwtHelper.getSecKeyCurveXYCalled)
    XCTAssertEqual(jwtHelper.hasValidSignatureJwtUsingCallsCount, 3)
    XCTAssertTrue(result)
  }

  func testValidate_WithNoIssuerOnJWT_ShouldReturnFalse() async throws {
    let result = try await validator.validate(.Mock.noIssuerSample)

    XCTAssertFalse(result)
    XCTAssertFalse(spyDidResolver.getJWKSFromCalled)
    XCTAssertFalse(jwtHelper.getSecKeyCurveXYCalled)
    XCTAssertFalse(jwtHelper.hasValidSignatureJwtUsingCalled)
  }

  func testValidate_WithNoValidPublicKey_ShouldReturnFalse() async throws {
    jwtHelper.getSecKeyCurveXYReturnValue = SecKeyTestsHelper.createPrivateKey()
    spyDidResolver.getJWKSFromReturnValue = [.Mock.invalidSample, .Mock.invalidSample, .Mock.invalidSample]
    jwtHelper.hasValidSignatureJwtUsingReturnValue = false

    let result = try await validator.validate(.Mock.sample, from: issuer)

    XCTAssertFalse(result)
    XCTAssertTrue(spyDidResolver.getJWKSFromCalled)
    XCTAssertTrue(jwtHelper.getSecKeyCurveXYCalled)
    XCTAssertTrue(jwtHelper.hasValidSignatureJwtUsingCalled)
  }

  func testValidate_WithNoPublicKey_ShouldReturnFalse() async throws {
    jwtHelper.hasValidSignatureJwtUsingReturnValue = true
    spyDidResolver.getJWKSFromReturnValue = []

    let result = try await validator.validate(.Mock.sample, from: issuer)

    XCTAssertFalse(result)
    XCTAssertTrue(spyDidResolver.getJWKSFromCalled)
    XCTAssertFalse(jwtHelper.getSecKeyCurveXYCalled)
    XCTAssertFalse(jwtHelper.hasValidSignatureJwtUsingCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var validator: JWTSignatureValidator!
  private var jwtHelper: JWTHelperProtocolSpy!
  private var spyDidResolver: DidResolverHelperProtocolSpy!
  // swiftlint:enable all

  private let issuer: String = "did:example:123456789"

}
