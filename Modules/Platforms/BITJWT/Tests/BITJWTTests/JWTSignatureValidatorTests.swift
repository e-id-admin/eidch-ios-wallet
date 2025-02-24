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
    spyDidResolver.getJWKSFromKeyIdentifierReturnValue = [.Mock.validSample]
    let mockSecKey = SecKeyTestsHelper.createPrivateKey()
    jwtHelper.getSecKeyCurveXYReturnValue = mockSecKey
    jwtHelper.hasValidSignatureJwtUsingReturnValue = true

    let result = try await validator.validate(.Mock.sample, did: issuer, kid: kid)

    XCTAssertTrue(result)
    XCTAssertEqual(JWT.Mock.sample.raw, jwtHelper.hasValidSignatureJwtUsingReceivedArguments?.jwt.raw)
    XCTAssertEqual(mockSecKey, jwtHelper.hasValidSignatureJwtUsingReceivedArguments?.publicKey)
  }

  func testValidate_WithMultipleJWKsOneValid_ShouldReturnTrue() async throws {
    spyDidResolver.getJWKSFromKeyIdentifierReturnValue = [.Mock.invalidSample, .Mock.invalidSample, .Mock.validSample]

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

    let result = try await validator.validate(.Mock.sample, did: issuer, kid: kid)

    XCTAssertEqual(spyDidResolver.getJWKSFromKeyIdentifierReceivedArguments?.did, issuer)
    XCTAssertEqual(spyDidResolver.getJWKSFromKeyIdentifierReceivedArguments?.keyIdentifier, kid)
    XCTAssertTrue(jwtHelper.getSecKeyCurveXYCalled)
    XCTAssertEqual(jwtHelper.hasValidSignatureJwtUsingCallsCount, 3)
    XCTAssertTrue(result)
  }

  func testValidate_WithNoValidPublicKey_ShouldReturnFalse() async throws {
    jwtHelper.getSecKeyCurveXYReturnValue = SecKeyTestsHelper.createPrivateKey()
    spyDidResolver.getJWKSFromKeyIdentifierReturnValue = [.Mock.invalidSample, .Mock.invalidSample, .Mock.invalidSample]
    jwtHelper.hasValidSignatureJwtUsingReturnValue = false

    let result = try await validator.validate(.Mock.sample, did: issuer, kid: kid)

    XCTAssertFalse(result)
    XCTAssertEqual(spyDidResolver.getJWKSFromKeyIdentifierReceivedArguments?.did, issuer)
    XCTAssertEqual(spyDidResolver.getJWKSFromKeyIdentifierReceivedArguments?.keyIdentifier, kid)
    XCTAssertTrue(jwtHelper.getSecKeyCurveXYCalled)
    XCTAssertEqual(jwtHelper.hasValidSignatureJwtUsingReceivedArguments?.jwt, .Mock.sample)
  }

  func testValidate_WithNoPublicKey_ShouldReturnFalse() async throws {
    jwtHelper.hasValidSignatureJwtUsingReturnValue = true
    spyDidResolver.getJWKSFromKeyIdentifierReturnValue = []

    let result = try await validator.validate(.Mock.sample, did: issuer, kid: kid)

    XCTAssertFalse(result)
    XCTAssertTrue(spyDidResolver.getJWKSFromKeyIdentifierCalled)
    XCTAssertFalse(jwtHelper.getSecKeyCurveXYCalled)
    XCTAssertFalse(jwtHelper.hasValidSignatureJwtUsingCalled)
  }

  func testValidate_didResolverThrows_ShouldManageSpecificException() async throws {
    let testingError = TestingError.error
    spyDidResolver.getJWKSFromKeyIdentifierThrowableError = testingError
    do {
      _ = try await validator.validate(.Mock.sample, did: issuer, kid: kid)
      XCTFail("Expected to throw an error, but it did not.")
    } catch JWTSignatureValidator.JWTSignatureValidatorError.cannotResolveDid {
      XCTAssertTrue(spyDidResolver.getJWKSFromKeyIdentifierCalled)
      XCTAssertFalse(jwtHelper.getSecKeyCurveXYCalled)
      XCTAssertFalse(jwtHelper.hasValidSignatureJwtUsingCalled)
    } catch {
      XCTFail("Unexpected error type")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var validator: JWTSignatureValidator!
  private var jwtHelper: JWTHelperProtocolSpy!
  private var spyDidResolver: DidResolverHelperProtocolSpy!
  // swiftlint:enable all

  private let issuer = "did:example:123456789"
  private let kid = "did:example:123456789#key-01"

}
