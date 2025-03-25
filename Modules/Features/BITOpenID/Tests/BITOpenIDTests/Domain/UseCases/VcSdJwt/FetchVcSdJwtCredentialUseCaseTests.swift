// swiftlint:disable all
import Factory
import XCTest
@testable import BITJWT
@testable import BITOpenID
@testable import BITSdJWT
@testable import BITTestingCore

// MARK: - FetchVcSdJwtCredentialUseCaseTests

final class FetchVcSdJwtCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyJWTSignatureValidator = JWTSignatureValidatorProtocolSpy()
    spyRepository = OpenIDRepositoryProtocolSpy()
    jwtContextHelper = JWTContextHelperProtocolSpy()
    vcSchemaService = VcSchemaServiceProtocolSpy()
    typeMetadataService = TypeMetadataServiceProtocolSpy()

    Container.shared.openIDRepository.register { self.spyRepository }
    Container.shared.jwtSignatureValidator.register { self.spyJWTSignatureValidator }
    Container.shared.jwtContextHelper.register { self.jwtContextHelper }
    Container.shared.vcSchemaService.register { self.vcSchemaService }
    Container.shared.typeMetadataService.register { self.typeMetadataService }

    useCase = FetchVcSdJwtCredentialUseCase()

    mockFetchCredentialContext = .Mock.sampleVcSdJwt
  }

  func testFetchHappyPath() async throws {
    let mockJWT = JWT.Mock.sample
    let mockCredentialResponse = CredentialResponse.Mock.sample
    let mockVcSdJwt = try VcSdJwt(from: mockCredentialResponse.rawCredential)

    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockCredentialResponse
    spyJWTSignatureValidator.validateDidKidReturnValue = true
    jwtContextHelper.jwtUsingKeyPairTypeReturnValue = mockJWT
    vcSchemaService.fetchForWithReturnValue = mockVcSchema
    vcSchemaService.validateWithReturnValue = true
    typeMetadataService.fetchReturnValue = mockTypeMetadata

    _ = try await useCase.execute(for: mockFetchCredentialContext)

    if let fetchArguments = spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReceivedArguments {
      XCTAssertEqual(fetchArguments.url, mockFetchCredentialContext.credentialEndpoint)
      XCTAssertEqual(fetchArguments.acccessToken, mockFetchCredentialContext.accessToken)
      XCTAssertEqual(fetchArguments.credentialRequestBody.format, mockFetchCredentialContext.format)
      XCTAssertEqual(fetchArguments.credentialRequestBody.proof?.proofType, "jwt")
      XCTAssertEqual(fetchArguments.credentialRequestBody.proof?.jwt, mockJWT.raw)
    } else {
      XCTFail("fetchCredential no arguments received")
    }

    XCTAssertNotNil(mockTypeMetadata.schemaUrl)
    XCTAssertNotNil(mockTypeMetadata.schemaIntegrity)
    XCTAssertEqual(typeMetadataService.fetchReceivedVc, mockVcSdJwt)
    XCTAssertEqual(vcSchemaService.fetchForWithReceivedArguments?.vc, mockVcSdJwt)
    XCTAssertEqual(vcSchemaService.fetchForWithReceivedArguments?.typeMetadata, mockTypeMetadata)

    XCTAssertEqual(spyJWTSignatureValidator.validateDidKidReceivedArguments?.jwt.raw, mockCredentialResponse.rawCredential)
  }

  func testFetchHappyPathWithoutHolderBinding() async throws {
    let mockCredentialResponse = CredentialResponse.Mock.sample
    let context = FetchCredentialContext.Mock.sampleVcSdJwtWithoutHolderBinding
    let mockVcSdJwt = try VcSdJwt(from: mockCredentialResponse.rawCredential)

    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockCredentialResponse
    spyJWTSignatureValidator.validateDidKidReturnValue = true
    vcSchemaService.fetchForWithReturnValue = mockVcSchema
    vcSchemaService.validateWithReturnValue = true
    typeMetadataService.fetchReturnValue = mockTypeMetadata

    _ = try await useCase.execute(for: context)

    if let fetchArguments = spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReceivedArguments {
      XCTAssertEqual(fetchArguments.url, mockFetchCredentialContext.credentialEndpoint)
      XCTAssertEqual(fetchArguments.acccessToken, mockFetchCredentialContext.accessToken)
      XCTAssertEqual(fetchArguments.credentialRequestBody.format, mockFetchCredentialContext.format)
      XCTAssertNil(fetchArguments.credentialRequestBody.proof)
    } else {
      XCTFail("fetchCredential no arguments received")
    }

    XCTAssertEqual(spyJWTSignatureValidator.validateDidKidReceivedArguments?.jwt.raw, mockCredentialResponse.rawCredential)
    XCTAssertNil(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReceivedArguments?.credentialRequestBody.proof)
    XCTAssertEqual(typeMetadataService.fetchReceivedVc, mockVcSdJwt)
    XCTAssertEqual(vcSchemaService.fetchForWithReceivedArguments?.vc, mockVcSdJwt)
    XCTAssertEqual(vcSchemaService.fetchForWithReceivedArguments?.typeMetadata, mockTypeMetadata)
  }

  func testCredentialValidation_fails() async throws {
    let mockJWT = JWT.Mock.sample
    let mockCredentialResponse = CredentialResponse.Mock.sample

    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockCredentialResponse
    spyJWTSignatureValidator.validateDidKidReturnValue = false
    jwtContextHelper.jwtUsingKeyPairTypeReturnValue = mockJWT

    do {
      _ = try await useCase.execute(for: mockFetchCredentialContext)
      XCTFail("An error was expected")
    } catch FetchAnyVerifiableCredentialError.validationFailed {
      if let fetchArguments = spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReceivedArguments {
        XCTAssertEqual(fetchArguments.url, mockFetchCredentialContext.credentialEndpoint)
        XCTAssertEqual(fetchArguments.acccessToken, mockFetchCredentialContext.accessToken)
        XCTAssertEqual(fetchArguments.credentialRequestBody.format, mockFetchCredentialContext.format)
        XCTAssertEqual(fetchArguments.credentialRequestBody.proof?.proofType, "jwt")
        XCTAssertEqual(fetchArguments.credentialRequestBody.proof?.jwt, mockJWT.raw)
      } else {
        XCTFail("fetchCredential no arguments received")
      }

      XCTAssertEqual(spyJWTSignatureValidator.validateDidKidReceivedArguments?.jwt.raw, mockCredentialResponse.rawCredential)
      XCTAssertEqual(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReceivedArguments?.credentialRequestBody.proof?.jwt, mockJWT.raw)
      XCTAssertFalse(typeMetadataService.fetchCalled)
      XCTAssertFalse(vcSchemaService.fetchForWithCalled)
      XCTAssertFalse(vcSchemaService.validateWithCalled)
    } catch {
      XCTFail("Another error was expected")
    }
  }

  func testCredentialValidation_unknownIssuer() async throws {
    jwtContextHelper.jwtUsingKeyPairTypeReturnValue = JWT.Mock.sample
    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = CredentialResponse.Mock.sample
    spyJWTSignatureValidator.validateDidKidThrowableError = JWTSignatureValidator.JWTSignatureValidatorError.cannotResolveDid(TestingError.error)

    do {
      _ = try await useCase.execute(for: mockFetchCredentialContext)
      XCTFail("An error was expected")
    } catch FetchAnyVerifiableCredentialError.unknownIssuer {
      XCTAssertTrue(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
      XCTAssertTrue(spyJWTSignatureValidator.validateDidKidCalled)
      XCTAssertFalse(typeMetadataService.fetchCalled)
      XCTAssertFalse(vcSchemaService.fetchForWithCalled)
      XCTAssertFalse(vcSchemaService.validateWithCalled)
    } catch {
      XCTFail("Another error was expected")
    }
  }

  // MARK: - TypeMetadataService

  func testFetchTypeMetadata_ThrowsError_failure() async throws {
    let mockJWT = JWT.Mock.sample
    let mockCredentialResponse = CredentialResponse.Mock.sample
    let mockVcSdJwt = try VcSdJwt(from: mockCredentialResponse.rawCredential)

    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockCredentialResponse
    spyJWTSignatureValidator.validateDidKidReturnValue = true
    jwtContextHelper.jwtUsingKeyPairTypeReturnValue = mockJWT
    typeMetadataService.fetchThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(for: mockFetchCredentialContext)
      XCTFail("An error was expected")
    } catch TestingError.error {
      XCTAssertFalse(vcSchemaService.validateWithCalled)
      XCTAssertFalse(vcSchemaService.fetchForWithCalled)
    } catch {
      XCTFail("Another error was expected")
    }
  }

  func testFetchTypeMetadata_ReturnsNil_failure() async throws {
    let mockJWT = JWT.Mock.sample
    let mockCredentialResponse = CredentialResponse.Mock.sample
    let mockVcSdJwt = try VcSdJwt(from: mockCredentialResponse.rawCredential)

    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockCredentialResponse
    spyJWTSignatureValidator.validateDidKidReturnValue = true
    jwtContextHelper.jwtUsingKeyPairTypeReturnValue = mockJWT
    typeMetadataService.fetchReturnValue = nil

    _ = try await useCase.execute(for: mockFetchCredentialContext)

    XCTAssertFalse(vcSchemaService.validateWithCalled)
    XCTAssertFalse(vcSchemaService.fetchForWithCalled)
  }

  // MARK: - FetchVcSchemaService

  func testFetchVcSchema_ThrowsError_failure() async throws {
    let mockJWT = JWT.Mock.sample
    let mockCredentialResponse = CredentialResponse.Mock.sample
    let mockVcSdJwt = try VcSdJwt(from: mockCredentialResponse.rawCredential)

    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockCredentialResponse
    spyJWTSignatureValidator.validateDidKidReturnValue = true
    jwtContextHelper.jwtUsingKeyPairTypeReturnValue = mockJWT
    typeMetadataService.fetchReturnValue = mockTypeMetadata
    vcSchemaService.fetchForWithThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(for: mockFetchCredentialContext)
      XCTFail("An error was expected")
    } catch TestingError.error {
      XCTAssertFalse(vcSchemaService.validateWithCalled)
    } catch {
      XCTFail("Another error was expected")
    }
  }

  func testFetchVcSchema_ReturnsNil_failure() async throws {
    let mockJWT = JWT.Mock.sample
    let mockCredentialResponse = CredentialResponse.Mock.sample
    let mockVcSdJwt = try VcSdJwt(from: mockCredentialResponse.rawCredential)

    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockCredentialResponse
    spyJWTSignatureValidator.validateDidKidReturnValue = true
    jwtContextHelper.jwtUsingKeyPairTypeReturnValue = mockJWT
    typeMetadataService.fetchReturnValue = mockTypeMetadata
    vcSchemaService.fetchForWithReturnValue = nil

    _ = try await useCase.execute(for: mockFetchCredentialContext)

    XCTAssertFalse(vcSchemaService.validateWithCalled)
  }

  // MARK: Private

  private var useCase: FetchVcSdJwtCredentialUseCase!
  private var spyJWTSignatureValidator: JWTSignatureValidatorProtocolSpy!
  private var spyRepository: OpenIDRepositoryProtocolSpy!
  private var mockFetchCredentialContext: FetchCredentialContext!
  private var jwtContextHelper: JWTContextHelperProtocolSpy!
  private var vcSchemaService: VcSchemaServiceProtocolSpy!
  private var typeMetadataService: TypeMetadataServiceProtocolSpy!

  private let mockVcSchema = VcSchema()
  private let mockTypeMetadata = TypeMetadata.Mock.sampleStandard
  private let mockTypeMetadataData = TypeMetadata.Mock.sampleStandardData
  // swiftlint:enable all
}
