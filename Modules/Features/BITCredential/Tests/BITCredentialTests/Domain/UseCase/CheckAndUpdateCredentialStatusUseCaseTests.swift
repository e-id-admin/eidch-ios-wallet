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
    anyCredentialSpy = AnyCredentialSpy()
    createAnyCredentialSpy = CreateAnyCredentialUseCaseProtocolSpy()
    localRepositorySpy = CredentialRepositoryProtocolSpy()
    validatorSpy = AnyStatusCheckValidatorProtocolSpy()

    Container.shared.createAnyCredentialUseCase.register { self.createAnyCredentialSpy }
    Container.shared.databaseCredentialRepository.register { self.localRepositorySpy }
    Container.shared.statusValidators.register { [AnyStatusType.tokenStatusList: self.validatorSpy] }
    Container.shared.dateBuffer.register { Self.buffer }

    useCase = CheckAndUpdateCredentialStatusUseCase()

    success()
  }

  func testCheckCredentialStatus_valid() async throws {
    mockCredential.status = .unknown
    success(status: .valid)

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .valid)
    mockCredential.status = .valid
    XCTAssertEqual(credential, mockCredential)
  }

  func testCheckCredentialStatus_expired() async throws {
    mockCredential.status = .valid
    anyCredentialSpy.validUntil = Date().advanced(by: -10)
    mockUpdate(expectedStatus: .expired)

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .expired)
    mockCredential.status = .expired
    XCTAssertEqual(credential, mockCredential)
    XCTAssertFalse(validatorSpy.validateIssuerCalled)
  }

  func testCheckCredentialStatus_validInFutureInsideBuffer() async throws {
    mockCredential.status = .unknown
    anyCredentialSpy.validFrom = Date().advanced(by: Self.buffer - 1)

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .valid)
    mockCredential.status = .valid
    XCTAssertEqual(credential, mockCredential)
  }

  func testCheckCredentialStatus_validInFuture() async throws {
    mockCredential.status = .valid
    anyCredentialSpy.validFrom = Date().advanced(by: Self.buffer + 1)
    mockUpdate(expectedStatus: .notYetValid)

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .notYetValid)
    mockCredential.status = .notYetValid
    XCTAssertEqual(credential, mockCredential)
    XCTAssertFalse(validatorSpy.validateIssuerCalled)
  }

  func testCheckCredentialStatus_suspended() async throws {
    mockCredential.status = .valid
    success(status: .suspended)

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .suspended)
    mockCredential.status = .suspended
    XCTAssertEqual(credential, mockCredential)
  }

  func testCheckCredentialStatus_revoked() async throws {
    mockCredential.status = .suspended
    success(status: .revoked)

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .revoked)
    mockCredential.status = .revoked
    XCTAssertEqual(credential, mockCredential)
  }

  func testCheckCredentialStatus_unknownIsNotSavedInRepository() async throws {
    mockCredential.status = .valid
    success(status: .unknown)

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .valid)
    XCTAssertEqual(credential, mockCredential)
    XCTAssertFalse(localRepositorySpy.updateCalled)
  }

  func testCheckCredentialStatus_noStatus_returnsUnknown() async throws {
    anyCredentialSpy.status = nil
    mockCredential.status = .unknown

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .unknown)
    XCTAssertEqual(credential, mockCredential)
    XCTAssertFalse(localRepositorySpy.updateCalled)
  }

  func testCheckCredentialStatus_noValidator_returnsUnknown() async throws {
    Container.shared.statusValidators.register { [:] }
    useCase = CheckAndUpdateCredentialStatusUseCase()
    mockCredential.status = .unknown

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .unknown)
    XCTAssertEqual(credential, mockCredential)
    XCTAssertFalse(localRepositorySpy.updateCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private static let issuer = "issuer"
  private static let buffer = 5.0

  private var mockCredential: Credential!
  private var anyCredentialSpy: AnyCredentialSpy!

  private var createAnyCredentialSpy: CreateAnyCredentialUseCaseProtocolSpy!
  private var validatorSpy: AnyStatusCheckValidatorProtocolSpy!
  private var localRepositorySpy: CredentialRepositoryProtocolSpy!

  private var useCase = CheckAndUpdateCredentialStatusUseCase()

  // swiftlint:enable all

  private func success(status: VcStatus = .valid) {
    mockCredential = Credential(payload: CredentialPayload.Mock.default, format: "vc+sd-jwt", issuer: Self.issuer)
    let anyStatusSpy = AnyStatusSpy()
    anyStatusSpy.type = .tokenStatusList
    anyCredentialSpy.status = anyStatusSpy
    anyCredentialSpy.issuer = Self.issuer
    anyCredentialSpy.validFrom = nil
    anyCredentialSpy.validUntil = nil

    createAnyCredentialSpy.executeFromFormatClosure = { payload, format in
      guard payload == self.mockCredential.payload, format == self.mockCredential.format else { fatalError("Received wrong arguments") }
      return self.anyCredentialSpy
    }
    mockValidator(status: status)
    mockUpdate(expectedStatus: status)
  }

  private func mockValidator(status: VcStatus) {
    validatorSpy.validateIssuerClosure = { anyStatus, issuer in
      guard anyStatus.type == self.anyCredentialSpy.status?.type, issuer == Self.issuer else { fatalError("Received wrong arguments") }
      return status
    }
  }

  private func mockUpdate(expectedStatus: VcStatus) {
    localRepositorySpy.updateClosure = { credential in
      var credentialCopy: Credential = self.mockCredential
      credentialCopy.status = expectedStatus
      guard credential == credentialCopy else { fatalError("Received wrong arguments") }
      return credential
    }
  }

}
