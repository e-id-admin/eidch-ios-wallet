import Factory
import Spyable
import XCTest
@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITTestingCore
@testable import BITVault

final class DeleteCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    keyManagerProtocolSpy = KeyManagerProtocolSpy()
    localRepositorySpy = CredentialRepositoryProtocolSpy()
    hasDeletedCredentialRepository = HasDeletedCredentialRepositoryProtocolSpy()

    Container.shared.keyManager.register { self.keyManagerProtocolSpy }
    Container.shared.databaseCredentialRepository.register { self.localRepositorySpy }
    Container.shared.hasDeletedCredentialRepository.register { self.hasDeletedCredentialRepository }

    useCase = DeleteCredentialUseCase()
  }

  func testDeleteCredential_Success() async throws {
    try await useCase.execute(mockCredential)

    XCTAssertEqual(keyManagerProtocolSpy.deleteKeyPairWithIdentifierAlgorithmReceivedArguments?.identifier, mockCredential.keyBindingIdentifier?.uuidString)
    XCTAssertEqual(keyManagerProtocolSpy.deleteKeyPairWithIdentifierAlgorithmReceivedArguments?.algorithm, VaultAlgorithm.eciesEncryptionStandardVariableIVX963SHA256AESGCM)
    XCTAssertEqual(localRepositorySpy.deleteReceivedId, mockCredential.id)
    XCTAssertTrue(hasDeletedCredentialRepository.setHasDeletedCredentialCalled)
  }

  func testDeleteCredential_WithoutPrivateKey() async throws {
    var credential = mockCredential
    credential.keyBindingAlgorithm = nil
    credential.keyBindingIdentifier = nil

    try await useCase.execute(credential)

    XCTAssertFalse(keyManagerProtocolSpy.deleteKeyPairWithIdentifierAlgorithmCalled)
    XCTAssertEqual(localRepositorySpy.deleteReceivedId, mockCredential.id)
    XCTAssertTrue(hasDeletedCredentialRepository.setHasDeletedCredentialCalled)
  }

  func testDeleteCredential_FailureOnVaultAlgorithm() async throws {
    var credential = mockCredential
    credential.keyBindingAlgorithm = "fake_algo"

    try await useCase.execute(credential)

    XCTAssertFalse(keyManagerProtocolSpy.deleteKeyPairWithIdentifierAlgorithmCalled)
    XCTAssertEqual(localRepositorySpy.deleteReceivedId, mockCredential.id)
    XCTAssertTrue(hasDeletedCredentialRepository.setHasDeletedCredentialCalled)
  }

  func testDeleteCredential_FailureOnVault() async throws {
    keyManagerProtocolSpy.deleteKeyPairWithIdentifierAlgorithmThrowableError = TestingError.error

    try await useCase.execute(mockCredential)

    XCTAssertTrue(keyManagerProtocolSpy.deleteKeyPairWithIdentifierAlgorithmCalled)
    XCTAssertEqual(localRepositorySpy.deleteReceivedId, mockCredential.id)
    XCTAssertTrue(hasDeletedCredentialRepository.setHasDeletedCredentialCalled)
  }

  func testDeleteCredential_FailureOnRepository() async throws {
    localRepositorySpy.deleteThrowableError = TestingError.error

    do {
      try await useCase.execute(mockCredential)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(localRepositorySpy.deleteCalled)
      XCTAssertEqual(localRepositorySpy.deleteCallsCount, 1)

      XCTAssertTrue(keyManagerProtocolSpy.deleteKeyPairWithIdentifierAlgorithmCalled)
      XCTAssertEqual(keyManagerProtocolSpy.deleteKeyPairWithIdentifierAlgorithmCallsCount, 1)

      XCTAssertFalse(hasDeletedCredentialRepository.setHasDeletedCredentialCalled)
      XCTAssertEqual(hasDeletedCredentialRepository.setHasDeletedCredentialCallsCount, 0)
    }
  }

  // MARK: Private

  private var mockCredential = Credential.Mock.sample
  private var useCase = DeleteCredentialUseCase()
  private var keyManagerProtocolSpy = KeyManagerProtocolSpy()
  private var localRepositorySpy = CredentialRepositoryProtocolSpy()
  private var hasDeletedCredentialRepository = HasDeletedCredentialRepositoryProtocolSpy()
}
