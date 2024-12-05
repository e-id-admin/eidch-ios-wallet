import Factory
import XCTest

@testable import BITAnyCredentialFormat
@testable import BITAnyCredentialFormatMocks
@testable import BITOpenID
@testable import BITTestingCore

final class FetchTrustStatementUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    Container.shared.openIDRepository.register { self.openIDRepositorySpy }
    Container.shared.trustRegistryRepository.register { self.trustRegistryRepositorySpy }
    Container.shared.validateTrustStatementUseCase.register { self.validateTrustStatementUseCaseSpy }

    useCase = FetchTrustStatementUseCase()
  }

  func testFetchTrustStatementCredential_success() async throws {
    let mockAnyCredential = MockAnyCredential()

    trustRegistryRepositorySpy.getTrustRegistryDomainForReturnValue = "registry"
    openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReturnValue = [ TrustStatement.Mock.sdJwtSample ]
    validateTrustStatementUseCaseSpy.executeReturnValue = true

    let trustStatement = try await useCase.execute(credential: mockAnyCredential)

    XCTAssertEqual(trustStatement?.iss, TrustStatement.Mock.validSample?.iss)

    XCTAssertTrue(trustRegistryRepositorySpy.getTrustRegistryDomainForCalled)
    XCTAssertTrue(validateTrustStatementUseCaseSpy.executeCalled)

    XCTAssertEqual(openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReceivedArguments?.issuerDid, mockAnyCredential.issuer)
  }

  func testFetchTrustStatementJwtRequestOject_success() async throws {
    let jwtRequestObject: JWTRequestObject = .Mock.sample

    Container.shared.baseRegistryDomainPattern.register { #"^did:([^:]+):[^:]+$"# }

    trustRegistryRepositorySpy.getTrustRegistryDomainForReturnValue = "registry"
    openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReturnValue = [ TrustStatement.Mock.sdJwtSample ]
    validateTrustStatementUseCaseSpy.executeReturnValue = true

    useCase = FetchTrustStatementUseCase()

    let trustStatement = try await useCase.execute(jwtRequestObject: jwtRequestObject)

    XCTAssertEqual(trustStatement?.iss, TrustStatement.Mock.validSample?.iss)
    XCTAssertTrue(trustRegistryRepositorySpy.getTrustRegistryDomainForCalled)
    XCTAssertEqual(validateTrustStatementUseCaseSpy.executeReceivedTrustStatement, trustStatement)
    XCTAssertEqual(openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReceivedArguments?.issuerDid, jwtRequestObject.jwt.iss)
  }

  func testFetchTrustStatementCredenialMultiple_success() async throws {
    let mockAnyCredential = MockAnyCredential()

    trustRegistryRepositorySpy.getTrustRegistryDomainForReturnValue = "registry"
    openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReturnValue = [
      TrustStatement.Mock.noVctClaimSdJwtSample,
      TrustStatement.Mock.unsupportedVctSdJwtSample,
      TrustStatement.Mock.sdJwtSample,
    ]
    validateTrustStatementUseCaseSpy.executeReturnValue = true

    let trustStatement = try await useCase.execute(credential: mockAnyCredential)

    XCTAssertEqual(trustStatement?.iss, TrustStatement.Mock.validSample?.iss)

    XCTAssertTrue(trustRegistryRepositorySpy.getTrustRegistryDomainForCalled)
    XCTAssertTrue(validateTrustStatementUseCaseSpy.executeCalled)
    XCTAssertEqual(validateTrustStatementUseCaseSpy.executeCallsCount, 1)
    XCTAssertEqual(openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReceivedArguments?.issuerDid, mockAnyCredential.issuer)
  }

  func testFetchTrustStatementCredentialWithInvalidBaseRegistry() async throws {
    let mockAnyCredential = MockAnyCredential()

    trustRegistryRepositorySpy.getTrustedDidsThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(credential: mockAnyCredential)
      XCTFail("An error was expected")
    } catch FetchTrustStatementUseCase.FetchTrustStatementUseCaseError.cannotParseTrustRegistryDomain {
      XCTAssertTrue(trustRegistryRepositorySpy.getTrustRegistryDomainForCalled)
      XCTAssertFalse(validateTrustStatementUseCaseSpy.executeCalled)
      XCTAssertFalse(openIDRepositorySpy.fetchTrustStatementsFromIssuerDidCalled)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  func testFetchTrustStatementCredentialWhenNoTrustStatements() async throws {
    let mockAnyCredential = MockAnyCredential()

    trustRegistryRepositorySpy.getTrustRegistryDomainForReturnValue = "registry"
    openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReturnValue = []

    let trustStatement = try await useCase.execute(credential: mockAnyCredential)

    XCTAssertTrue(trustRegistryRepositorySpy.getTrustRegistryDomainForCalled)
    XCTAssertFalse(validateTrustStatementUseCaseSpy.executeCalled)
    XCTAssertEqual(openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReceivedArguments?.issuerDid, mockAnyCredential.issuer)
    XCTAssertNil(trustStatement)
  }

  func testFetchTrustStatementCredentialWithInvalidTrustStatement() async throws {
    let mockAnyCredential = MockAnyCredential()

    trustRegistryRepositorySpy.getTrustRegistryDomainForReturnValue = "registry"
    openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReturnValue = [TrustStatement.Mock.invalidSample]

    let trustStatement = try await useCase.execute(credential: mockAnyCredential)

    XCTAssertTrue(trustRegistryRepositorySpy.getTrustRegistryDomainForCalled)
    XCTAssertFalse(validateTrustStatementUseCaseSpy.executeCalled)
    XCTAssertEqual(openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReceivedArguments?.issuerDid, mockAnyCredential.issuer)
    XCTAssertNil(trustStatement)
  }

  func testFetchTrustStatementCredentialWhenValidationFails() async throws {
    let mockAnyCredential = MockAnyCredential()

    trustRegistryRepositorySpy.getTrustRegistryDomainForReturnValue = "registry"
    openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReturnValue = [ TrustStatement.Mock.sdJwtSample ]
    validateTrustStatementUseCaseSpy.executeReturnValue = false

    let trustStatement = try await useCase.execute(credential: mockAnyCredential)

    XCTAssertTrue(trustRegistryRepositorySpy.getTrustRegistryDomainForCalled)
    XCTAssertTrue(validateTrustStatementUseCaseSpy.executeCalled)
    XCTAssertEqual(openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReceivedArguments?.issuerDid, mockAnyCredential.issuer)
    XCTAssertNil(trustStatement)
  }

  func testFetchTrustStatementCredentialWhenNoVctClaims() async throws {
    let mockAnyCredential = MockAnyCredential()

    trustRegistryRepositorySpy.getTrustRegistryDomainForReturnValue = "registry"
    openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReturnValue = [ TrustStatement.Mock.noVctClaimSdJwtSample ]

    let trustStatement = try await useCase.execute(credential: mockAnyCredential)

    XCTAssertTrue(trustRegistryRepositorySpy.getTrustRegistryDomainForCalled)
    XCTAssertEqual(openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReceivedArguments?.issuerDid, mockAnyCredential.issuer)
    XCTAssertFalse(validateTrustStatementUseCaseSpy.executeCalled)
    XCTAssertNil(trustStatement)
  }

  func testFetchTrustStatementCredentialNotSupportedVctClaims() async throws {
    let mockAnyCredential = MockAnyCredential()

    trustRegistryRepositorySpy.getTrustRegistryDomainForReturnValue = "registry"
    openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReturnValue = [ TrustStatement.Mock.unsupportedVctSdJwtSample ]

    let trustStatement = try await useCase.execute(credential: mockAnyCredential)

    XCTAssertTrue(trustRegistryRepositorySpy.getTrustRegistryDomainForCalled)
    XCTAssertEqual(openIDRepositorySpy.fetchTrustStatementsFromIssuerDidReceivedArguments?.issuerDid, mockAnyCredential.issuer)
    XCTAssertFalse(validateTrustStatementUseCaseSpy.executeCalled)
    XCTAssertNil(trustStatement)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockIssuer = "did:tdw:mock=:mock.swiyu.admin.ch:api:v1:did:25c2db14-8dc8-4e58-933f-070048079748"
  private var useCase: FetchTrustStatementUseCase!
  private var openIDRepositorySpy = OpenIDRepositoryProtocolSpy()
  private var trustRegistryRepositorySpy = TrustRegistryRepositoryProtocolSpy()
  private var validateTrustStatementUseCaseSpy = ValidateTrustStatementUseCaseProtocolSpy()
  // swiftlint:enable all
}
