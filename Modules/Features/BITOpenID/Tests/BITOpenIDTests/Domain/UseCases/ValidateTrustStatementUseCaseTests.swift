import Factory
import XCTest

@testable import BITCrypto
@testable import BITJWT
@testable import BITOpenID
@testable import BITTestingCore

final class ValidateTrustStatementUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    Container.shared.trustRegistryRepository.register { self.trustRegistryRepository }
    Container.shared.jwtSignatureValidator.register { self.jwtSignatureValidator }
    Container.shared.tokenStatusListValidator.register { self.tokenStatusListValidator }

    useCase = ValidateTrustStatementUseCase()
  }

  func testValidateTrustStatement() async throws {
    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot decode trust statement")
    }

    trustRegistryRepository.getTrustedDidsReturnValue = trustedDids
    jwtSignatureValidator.validateReturnValue = true
    tokenStatusListValidator.validateIssuerReturnValue = .valid

    let result = await useCase.execute(mockTrustStatement)

    XCTAssertTrue(result)
    XCTAssertTrue(trustRegistryRepository.getTrustedDidsCalled)
    XCTAssertEqual(jwtSignatureValidator.validateReceivedInvocations.first?.raw, mockTrustStatement.raw)
    XCTAssertEqual(tokenStatusListValidator.validateIssuerReceivedArguments?.issuer, mockTrustStatement.issuer)
    XCTAssertEqual(tokenStatusListValidator.validateIssuerReceivedArguments?.anyStatus.type, mockTrustStatement.status?.type)
  }

  func testValidateNotTrustedStatement() async throws {
    guard let mockTrustStatement: TrustStatement = .Mock.notTrustedSample else {
      fatalError("Cannot decode trust statement")
    }

    trustRegistryRepository.getTrustedDidsReturnValue = trustedDids
    jwtSignatureValidator.validateReturnValue = true

    let result = await useCase.execute(mockTrustStatement)

    XCTAssertFalse(result)
    XCTAssertTrue(trustRegistryRepository.getTrustedDidsCalled)
    XCTAssertFalse(jwtSignatureValidator.validateCalled)
  }

  func testValidateNotValidSignatureTrustStatement() async throws {
    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot decode trust statement")
    }

    trustRegistryRepository.getTrustedDidsReturnValue = trustedDids
    jwtSignatureValidator.validateReturnValue = false

    let result = await useCase.execute(mockTrustStatement)

    XCTAssertFalse(result)
    XCTAssertTrue(trustRegistryRepository.getTrustedDidsCalled)
    XCTAssertEqual(jwtSignatureValidator.validateReceivedInvocations.first?.raw, mockTrustStatement.raw)
  }

  func testValidateValidatorThrowsTrustStatement() async throws {
    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot decode trust statement")
    }

    trustRegistryRepository.getTrustedDidsReturnValue = trustedDids
    jwtSignatureValidator.validateThrowableError = TestingError.error

    let result = await useCase.execute(mockTrustStatement)

    XCTAssertFalse(result)
    XCTAssertTrue(trustRegistryRepository.getTrustedDidsCalled)
    XCTAssertEqual(jwtSignatureValidator.validateReceivedInvocations.first?.raw, mockTrustStatement.raw)
  }

  func testValidateTrustStatementWithNotValidStatus() async throws {
    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot decode trust statement")
    }

    jwtSignatureValidator.validateReturnValue = true
    trustRegistryRepository.getTrustedDidsReturnValue = trustedDids
    tokenStatusListValidator.validateIssuerReturnValue = .revoked

    let result = await useCase.execute(mockTrustStatement)

    XCTAssertFalse(result)
    XCTAssertTrue(trustRegistryRepository.getTrustedDidsCalled)
    XCTAssertEqual(jwtSignatureValidator.validateReceivedInvocations.first?.raw, mockTrustStatement.raw)
    XCTAssertEqual(tokenStatusListValidator.validateIssuerReceivedArguments?.issuer, mockTrustStatement.issuer)
    XCTAssertEqual(tokenStatusListValidator.validateIssuerReceivedArguments?.anyStatus.type, mockTrustStatement.status?.type)
  }

  // MARK: Private

  // swiftlint:disable all
  private var jwtSignatureValidator = JWTSignatureValidatorProtocolSpy()
  private var useCase: ValidateTrustStatementUseCase!
  private var trustRegistryRepository = TrustRegistryRepositoryProtocolSpy()
  private var tokenStatusListValidator = AnyStatusCheckValidatorProtocolSpy()
  // swiftlint:enable all

  private let trustedDids: [String] = [
    "did:tdw:123:identifier.domain.ch:api:v1:did:123",
    "did:tdw:123:identifier.domain.ch:api:v1:did:456",
  ]

}
