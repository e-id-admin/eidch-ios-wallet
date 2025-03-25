// swiftlint:disable implicitly_unwrapped_optional
import Factory
import XCTest
@testable import BITCrypto
@testable import BITOpenID
@testable import BITSdJWT
@testable import BITTestingCore

final class VcSchemaServiceTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = OpenIDRepositoryProtocolSpy()
    sriValidator = SRIValidatorProtocolSpy()
    jsonSchemaValidator = JsonSchemaSpy()

    Container.shared.openIDRepository.register { self.repository }
    Container.shared.sriValidator.register { self.sriValidator }
    Container.shared.jsonSchemaValidator.register { self.jsonSchemaValidator }

    service = VcSchemaService()
  }

  func testFetchVcSchema_success() async throws {
    let mockVcSdJwt = try VcSdJwt(from: CredentialResponse.Mock.sample.rawCredential)
    sriValidator.validateWithReturnValue = true
    repository.fetchVcSchemaDataFromReturnValue = mockVcSchemaData

    let vcSchema = try await service.fetch(for: mockVcSdJwt, with: mockTypeMetadata)

    XCTAssertNotNil(vcSchema)
    XCTAssertEqual(repository.fetchVcSchemaDataFromReceivedUrl, mockTypeMetadata.schemaUrl)
    XCTAssertEqual(sriValidator.validateWithReceivedArguments?.data, mockVcSchemaData)
    XCTAssertEqual(sriValidator.validateWithReceivedArguments?.integrity, mockTypeMetadata.schemaIntegrity)
  }

  func testFetchVcSchema_withoutSchemaUrl_failure() async throws {
    let mockVcSdJwt = try VcSdJwt(from: CredentialResponse.Mock.sample.rawCredential)

    let vcSchema = try await service.fetch(for: mockVcSdJwt, with: .Mock.sampleWithoutSchemaUrl)

    XCTAssertNil(vcSchema)
    XCTAssertFalse(repository.fetchVcSchemaDataFromCalled)
    XCTAssertFalse(sriValidator.validateWithCalled)
  }

  func testFetchVcSchema_repositoryError_failure() async throws {
    let mockVcSdJwt = try VcSdJwt(from: CredentialResponse.Mock.sample.rawCredential)
    repository.fetchVcSchemaDataFromThrowableError = TestingError.error

    do {
      _ = try await service.fetch(for: mockVcSdJwt, with: mockTypeMetadata)
      XCTFail("Expected an error")
    } catch TestingError.error {
      XCTAssertFalse(sriValidator.validateWithCalled)
    } catch {
      XCTFail("Unexpected error")
    }
  }

  func testFetchVcSchema_withoutUrlIntegrity_failure() async throws {
    let mockVcSdJwt = try VcSdJwt(from: CredentialResponse.Mock.sample.rawCredential)
    let mockTypeMetadata: TypeMetadata = .Mock.sampleWithoutUrlIntegrity
    repository.fetchVcSchemaDataFromReturnValue = mockVcSchemaData

    let vcSchema = try await service.fetch(for: mockVcSdJwt, with: mockTypeMetadata)

    XCTAssertNotNil(mockTypeMetadata.schemaUrl)
    XCTAssertEqual(repository.fetchVcSchemaDataFromReceivedUrl, mockTypeMetadata.schemaUrl)
    XCTAssertFalse(sriValidator.validateWithCalled)
  }

  func testFetchVcSchema_sriValidationError_failure() async throws {
    let mockVcSdJwt = try VcSdJwt(from: CredentialResponse.Mock.sample.rawCredential)
    sriValidator.validateWithThrowableError = TestingError.error
    repository.fetchVcSchemaDataFromReturnValue = mockVcSchemaData

    do {
      _ = try await service.fetch(for: mockVcSdJwt, with: mockTypeMetadata)
      XCTFail("Expected an error")
    } catch TestingError.error {
      XCTAssertEqual(repository.fetchVcSchemaDataFromReceivedUrl, mockTypeMetadata.schemaUrl)
      XCTAssertTrue(sriValidator.validateWithCalled)
    } catch {
      XCTFail("Unexpected error")
    }
  }

  func testFetchVcSchema_sriValidationReturnsFalse_failure() async throws {
    let mockVcSdJwt = try VcSdJwt(from: CredentialResponse.Mock.sample.rawCredential)
    sriValidator.validateWithReturnValue = false
    repository.fetchVcSchemaDataFromReturnValue = mockVcSchemaData

    do {
      _ = try await service.fetch(for: mockVcSdJwt, with: mockTypeMetadata)
      XCTFail("Expected an error")
    } catch VcSchemaServiceError.invalidVcSchema {
      XCTAssertEqual(repository.fetchVcSchemaDataFromReceivedUrl, mockTypeMetadata.schemaUrl)
      XCTAssertTrue(sriValidator.validateWithCalled)
    } catch {
      XCTFail("Unexpected error")
    }
  }

  func testValidateVcSchema_success() async throws {
    let mockVcSdJwt = try VcSdJwt(from: CredentialResponse.Mock.sample.rawCredential)
    jsonSchemaValidator.validateWithReturnValue = true

    let result = service.validate(mockVcSchemaData, with: mockVcSdJwt)

    XCTAssertTrue(result)
    XCTAssertEqual(jsonSchemaValidator.validateWithReceivedArguments?.jsonSchema, mockVcSchemaData)
  }

  func testValidateVcSchema_jsonSchemaValidatorReturnsFalse_failure() async throws {
    let mockVcSdJwt = try VcSdJwt(from: CredentialResponse.Mock.sample.rawCredential)
    jsonSchemaValidator.validateWithReturnValue = false

    let result = service.validate(mockVcSchemaData, with: mockVcSdJwt)

    XCTAssertFalse(result)
    XCTAssertEqual(jsonSchemaValidator.validateWithReceivedArguments?.jsonSchema, mockVcSchemaData)
  }

  func testValidateVcSchema_jsonSchemaValidatorThrowsError_failure() async throws {
    let mockVcSdJwt = try VcSdJwt(from: CredentialResponse.Mock.sample.rawCredential)
    jsonSchemaValidator.validateWithThrowableError = TestingError.error

    let result = service.validate(mockVcSchemaData, with: mockVcSdJwt)

    XCTAssertFalse(result)
    XCTAssertEqual(jsonSchemaValidator.validateWithReceivedArguments?.jsonSchema, mockVcSchemaData)
  }

  // MARK: Private

  private var sriValidator: SRIValidatorProtocolSpy!
  private var repository: OpenIDRepositoryProtocolSpy!
  private var jsonSchemaValidator: JsonSchemaSpy!
  private var service: VcSchemaService!
  private var mockVcSdJwt: VcSdJwt!

  private let mockVcSchemaData = VcSchema()
  private let mockTypeMetadata = TypeMetadata.Mock.sampleStandard
  private let mockTypeMetadataData = TypeMetadata.Mock.sampleStandardData
}

// swiftlint:enable implicitly_unwrapped_optional
