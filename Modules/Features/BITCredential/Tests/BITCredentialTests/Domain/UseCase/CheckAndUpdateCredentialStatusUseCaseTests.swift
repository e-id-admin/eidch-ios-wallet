import BITCore
import Factory
import XCTest
@testable import BITAnyCredentialFormat
@testable import BITAnyCredentialFormatMocks
@testable import BITCredential
@testable import BITCredentialShared
@testable import BITOpenID
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore

final class CheckAndUpdateCredentialStatusUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    localRepositorySpy = CredentialRepositoryProtocolSpy()
    validator = AnyStatusCheckValidatorProtocolSpy()

    useCase = CheckAndUpdateCredentialStatusUseCase(localRepository: localRepositorySpy, validators: [AnyStatusType.tokenStatusList: validator])

    success()
  }

  func testCheckCredentialStatus_valid() async throws {
    var currentCredential = mockCredential
    currentCredential.status = .unknown

    let credential = try await useCase.execute(for: currentCredential)

    XCTAssertEqual(credential.status, .valid)
    currentCredential.status = .valid
    XCTAssertEqual(localRepositorySpy.updateReceivedCredential, currentCredential)
  }

  func testCheckCredentialStatus_expired() async throws {
    var mockCredential = Credential(payload: CredentialPayload.Mock.expired, format: "vc+sd-jwt", issuer: "")
    mockCredential.status = .valid

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .expired)
    mockCredential.status = .expired
    XCTAssertFalse(validator.validateIssuerCalled)
    XCTAssertEqual(localRepositorySpy.updateReceivedCredential, mockCredential)
  }

  func testCheckCredentialStatus_suspended() async throws {
    var currentCredential = mockCredential
    currentCredential.status = .valid

    validator.validateIssuerReturnValue = .suspended

    let credential = try await useCase.execute(for: currentCredential)

    XCTAssertEqual(credential.status, .suspended)
    currentCredential.status = .suspended
    XCTAssertEqual(localRepositorySpy.updateReceivedCredential, currentCredential)
  }

  func testCheckCredentialStatus_revoked() async throws {
    var currentCredential = mockCredential
    currentCredential.status = .suspended

    validator.validateIssuerReturnValue = .revoked

    let credential = try await useCase.execute(for: currentCredential)

    XCTAssertEqual(credential.status, .revoked)
    currentCredential.status = .revoked
    XCTAssertEqual(localRepositorySpy.updateReceivedCredential, currentCredential)
  }

  func testCheckCredentialStatus_unknownIsNotSavedInRepository() async throws {
    var currentCredential = mockCredential
    currentCredential.status = .valid

    validator.validateIssuerReturnValue = .unknown

    let credential = try await useCase.execute(for: currentCredential)

    XCTAssertEqual(credential.status, .valid)
    XCTAssertFalse(localRepositorySpy.updateCalled)
  }

  func testCheckCredentialStatus_noStatus_returnsUnknown() async throws {
    var currentCredential = Credential(payload: VcSdJwt.Mock.sampleNoStatusData, format: "vc+sd-jwt", issuer: "")
    currentCredential.status = .unknown

    let credential = try await useCase.execute(for: currentCredential)

    XCTAssertEqual(credential.status, .unknown)
    XCTAssertFalse(localRepositorySpy.updateCalled)
  }

  func testCheckCredentialStatus_noValidator_returnsUnknown() async throws {
    useCase = CheckAndUpdateCredentialStatusUseCase(localRepository: localRepositorySpy, validators: [:])
    var currentCredential = mockCredential
    currentCredential.status = .unknown

    let credential = try await useCase.execute(for: currentCredential)

    XCTAssertEqual(credential.status, .unknown)
    XCTAssertFalse(localRepositorySpy.updateCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockCredential = Credential(payload: CredentialPayload.Mock.default, format: "vc+sd-jwt", issuer: "")
  private var useCase = CheckAndUpdateCredentialStatusUseCase()
  private var localRepositorySpy = CredentialRepositoryProtocolSpy()
  private var validator = AnyStatusCheckValidatorProtocolSpy()

  // swiftlint:enable all

  private func success() {
    localRepositorySpy.updateClosure = { credential in credential }
    validator.validateIssuerReturnValue = .valid
  }

}
