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
    jwtSignatureValidator.validateDidKidReturnValue = true
    tokenStatusListValidator.validateIssuerReturnValue = .valid

    let result = await useCase.execute(mockTrustStatement)

    XCTAssertTrue(result)
    XCTAssertTrue(trustRegistryRepository.getTrustedDidsCalled)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.jwt.raw, mockTrustStatement.raw)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.did, mockTrustStatement.issuer)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.kid, mockTrustStatement.kid)
    XCTAssertEqual(tokenStatusListValidator.validateIssuerReceivedArguments?.issuer, mockTrustStatement.issuer)
    XCTAssertEqual(tokenStatusListValidator.validateIssuerReceivedArguments?.anyStatus.type, mockTrustStatement.status?.type)
  }

  func testValidateNotTrustedStatement() async throws {
    guard let mockTrustStatement: TrustStatement = .Mock.notTrustedSample else {
      fatalError("Cannot decode trust statement")
    }

    trustRegistryRepository.getTrustedDidsReturnValue = trustedDids
    jwtSignatureValidator.validateDidKidReturnValue = true

    let result = await useCase.execute(mockTrustStatement)

    XCTAssertFalse(result)
    XCTAssertTrue(trustRegistryRepository.getTrustedDidsCalled)
  }

  func testValidateNotValidSignatureTrustStatement() async throws {
    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot decode trust statement")
    }

    trustRegistryRepository.getTrustedDidsReturnValue = trustedDids
    jwtSignatureValidator.validateDidKidReturnValue = false

    let result = await useCase.execute(mockTrustStatement)

    XCTAssertFalse(result)
    XCTAssertTrue(trustRegistryRepository.getTrustedDidsCalled)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.jwt.raw, mockTrustStatement.raw)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.did, mockTrustStatement.issuer)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.kid, mockTrustStatement.kid)
  }

  func testValidateValidatorThrowsTrustStatement() async throws {
    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot decode trust statement")
    }

    trustRegistryRepository.getTrustedDidsReturnValue = trustedDids
    jwtSignatureValidator.validateDidKidThrowableError = TestingError.error

    let result = await useCase.execute(mockTrustStatement)

    XCTAssertFalse(result)
    XCTAssertTrue(trustRegistryRepository.getTrustedDidsCalled)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.jwt.raw, mockTrustStatement.raw)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.did, mockTrustStatement.issuer)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.kid, mockTrustStatement.kid)
  }

  func testValidateTrustStatementWithNotValidStatus() async throws {
    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot decode trust statement")
    }

    jwtSignatureValidator.validateDidKidReturnValue = true
    trustRegistryRepository.getTrustedDidsReturnValue = trustedDids
    tokenStatusListValidator.validateIssuerReturnValue = .revoked

    let result = await useCase.execute(mockTrustStatement)

    XCTAssertFalse(result)
    XCTAssertTrue(trustRegistryRepository.getTrustedDidsCalled)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.jwt.raw, mockTrustStatement.raw)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.did, mockTrustStatement.issuer)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.kid, mockTrustStatement.kid)
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
