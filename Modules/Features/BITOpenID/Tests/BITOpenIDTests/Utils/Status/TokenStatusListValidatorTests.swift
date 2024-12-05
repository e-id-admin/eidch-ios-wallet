import Factory
import Foundation
import XCTest

@testable import BITAnyCredentialFormatMocks
@testable import BITJWT
@testable import BITOpenID
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore

// MARK: - TokenStatusListValidatorTests

final class TokenStatusListValidatorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyOpenIdRepository = OpenIDRepositoryProtocolSpy()
    Container.shared.openIDRepository.register { self.spyOpenIdRepository }

    spyTokenStatusListDecoder = TokenStatusListDecoderProtocolSpy()
    Container.shared.tokenStatusListDecoder.register { self.spyTokenStatusListDecoder }

    spyJwtSignatureValidator = JWTSignatureValidatorProtocolSpy()
    Container.shared.jwtSignatureValidator.register { self.spyJwtSignatureValidator }

    validator = TokenStatusListValidator()
  }

  func testValidate_ValidCredential_ShouldReturnValid() async throws {
    let statusJwt = JWT.Mock.validStatusSample

    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = statusJwt
    spyJwtSignatureValidator.validateReturnValue = true
    spyTokenStatusListDecoder.decodeIndexReturnValue = StatusCode(0)

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .valid)
    XCTAssertEqual(statusJwt.raw, spyTokenStatusListDecoder.decodeIndexReceivedArguments?.rawJWT)
    XCTAssertEqual(285, spyTokenStatusListDecoder.decodeIndexReceivedArguments?.index)
    XCTAssertEqual(statusJwt.raw, spyJwtSignatureValidator.validateReceivedInvocations.first?.raw)
  }

  func testValidate_RevokedCredential_ShouldReturnRevoked() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.validStatusSample
    spyJwtSignatureValidator.validateReturnValue = true
    spyTokenStatusListDecoder.decodeIndexReturnValue = StatusCode(1)

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .revoked)
  }

  func testValidate_SuspendedCredential_ShouldReturnSuspended() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.validStatusSample
    spyJwtSignatureValidator.validateReturnValue = true
    spyTokenStatusListDecoder.decodeIndexReturnValue = StatusCode(2)

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .suspended)
  }

  func testValidate_UnsupportedCredentialStatus_ShouldReturnUnsupported() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.validStatusSample
    spyJwtSignatureValidator.validateReturnValue = true
    spyTokenStatusListDecoder.decodeIndexReturnValue = StatusCode(3)

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .unsupported)
  }

  func testValidate_FetchThrowsError_ShouldReturnUnknown() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromThrowableError = TestingError.error

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .unknown)
    XCTAssertTrue(spyOpenIdRepository.fetchCredentialStatusFromCalled)
  }

  func testValidate_WrongStatusListType_ShouldReturnUnknown() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.tokenStatusListWrongType

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .unknown)
    XCTAssertTrue(spyOpenIdRepository.fetchCredentialStatusFromCalled)
  }

  func testValidate_StatusListWithoutIssuedAt_ShouldReturnUnknown() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.tokenStatusListWithoutIssuedAt

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .unknown)
    XCTAssertTrue(spyOpenIdRepository.fetchCredentialStatusFromCalled)
  }

  func testValidate_StatusListWithWrongSubject_ShouldReturnUnknown() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.tokenStatusListWrongSubject

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .unknown)
    XCTAssertTrue(spyOpenIdRepository.fetchCredentialStatusFromCalled)
  }

  func testValidate_StatusListWithoutIssuer_ShouldReturnUnknown() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.tokenStatusListWrongSubject

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .unknown)
    XCTAssertTrue(spyOpenIdRepository.fetchCredentialStatusFromCalled)
  }

  func testValidate_StatusListWithWrongIssuer_ShouldReturnUnknown() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.tokenStatusListWrongIssuer

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .unknown)
    XCTAssertTrue(spyOpenIdRepository.fetchCredentialStatusFromCalled)
  }

  func testValidate_StatusListInvalidSignature_ShouldReturnUnknown() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.validStatusSample
    spyJwtSignatureValidator.validateReturnValue = false

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .unknown)
    XCTAssertTrue(spyJwtSignatureValidator.validateCalled)
  }

  func testValidate_StatusListNotExpired_ShouldReturnUnknown() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.tokenStatusListNotExpired
    spyJwtSignatureValidator.validateReturnValue = true
    spyTokenStatusListDecoder.decodeIndexReturnValue = StatusCode(0)

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .valid)
  }

  func testValidate_StatusListExpired_ShouldReturnUnknown() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.tokenStatusListExpired
    spyJwtSignatureValidator.validateReturnValue = true

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .unknown)
    XCTAssertTrue(spyOpenIdRepository.fetchCredentialStatusFromCalled)
  }

  func testValidate_ValidatorThrowsError_ShouldReturnUnknown() async throws {
    spyOpenIdRepository.fetchCredentialStatusFromReturnValue = JWT.Mock.validStatusSample
    spyJwtSignatureValidator.validateThrowableError = TestingError.error

    let result = await validator.validate(mockStatus, issuer: mockIssuer)

    XCTAssertEqual(result, .unknown)
    XCTAssertTrue(spyJwtSignatureValidator.validateCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var validator: TokenStatusListValidator!
  private var spyOpenIdRepository: OpenIDRepositoryProtocolSpy!
  private var spyTokenStatusListDecoder: TokenStatusListDecoderProtocolSpy!
  private var spyJwtSignatureValidator: JWTSignatureValidatorProtocolSpy!
  private var mockStatus = VcSdJwt.Mock.sample.status!
  private var mockIssuer = VcSdJwt.Mock.sample.issuer
  // swiftlint:enable all
}
