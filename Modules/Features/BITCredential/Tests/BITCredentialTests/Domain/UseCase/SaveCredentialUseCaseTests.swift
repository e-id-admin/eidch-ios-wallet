import BITCrypto
import Factory
import Spyable
import XCTest
@testable import BITAnyCredentialFormat
@testable import BITAnyCredentialFormatMocks
@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITOpenID
@testable import BITTestingCore

// MARK: - SaveCredentialUseCaseTests

final class SaveCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = CredentialRepositoryProtocolSpy()
    Container.shared.databaseCredentialRepository.register { self.repository }
    useCase = SaveCredentialUseCase()
  }

  func testSaveCredentialHappyPath() async throws {
    let metadataWrapper = CredentialMetadataWrapper.Mock.sample
    let mockCredential = Credential.Mock.sample
    let mockCredentialWithKeyBinding = makeCredentialWithKeyBinding()
    let mockAnyCredential = mockCredentialWithKeyBinding.credential
    guard let mockClaimPayload = mockAnyCredential.raw.data(using: .utf8) else {
      XCTFail("Cannot convert raw to Data")
      return
    }

    repository.createCredentialReturnValue = mockCredential

    let credential = try await useCase.execute(credential: mockCredentialWithKeyBinding.credential, keyPair: mockCredentialWithKeyBinding.keyPair, metadataWrapper: metadataWrapper)

    XCTAssertEqual(credential, mockCredential)
    XCTAssertTrue(repository.createCredentialCalled)
    XCTAssertEqual(repository.createCredentialCallsCount, 1)
    XCTAssertEqual(mockAnyCredential.format, repository.createCredentialReceivedCredential?.format)
    XCTAssertEqual(mockClaimPayload, repository.createCredentialReceivedCredential?.payload)
    XCTAssertEqual(mockAnyCredential.claims.count, repository.createCredentialReceivedCredential?.claims.count)
    XCTAssertEqual(mockAnyCredential.claims.first?.key, repository.createCredentialReceivedCredential?.claims.first?.key)
    XCTAssertEqual(mockAnyCredential.claims.first?.value?.rawValue, repository.createCredentialReceivedCredential?.claims.first?.value)
    XCTAssertFalse(repository.deleteCalled)
    XCTAssertFalse(repository.updateCalled)
    XCTAssertFalse(repository.getIdCalled)
  }

  func testSaveCredentialFailurePath() async throws {
    let metadataWrapper = CredentialMetadataWrapper.Mock.sample
    repository.createCredentialThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(credential: MockAnyCredential(), keyPair: nil, metadataWrapper: metadataWrapper)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(repository.createCredentialCalled)
      XCTAssertEqual(repository.createCredentialCallsCount, 1)
      XCTAssertFalse(repository.deleteCalled)
      XCTAssertFalse(repository.updateCalled)
      XCTAssertFalse(repository.getIdCalled)
    } catch {
      XCTFail("Unexpected error")
    }
  }

  func testSaveCredential_saveActivityFails() async throws {
    let metadataWrapper = CredentialMetadataWrapper.Mock.sample
    let mockCredential = Credential.Mock.sample

    repository.createCredentialReturnValue = mockCredential
    let expectation = expectation(description: "saveCredential does not fail if saveActivity does")

    Task {
      do {
        let credential = try await useCase.execute(credential: MockAnyCredential(), keyPair: nil, metadataWrapper: metadataWrapper)
        XCTAssertNoThrow(credential)
        XCTAssertEqual(credential, mockCredential)
        XCTAssertTrue(repository.createCredentialCalled)
        XCTAssertEqual(repository.createCredentialCallsCount, 1)
        XCTAssertFalse(repository.deleteCalled)
        XCTAssertFalse(repository.updateCalled)
        XCTAssertFalse(repository.getIdCalled)
        expectation.fulfill()
      } catch {
        XCTFail("saveCredential failed: \(error)")
      }
    }

    await fulfillment(of: [expectation], timeout: 5)
  }

  // MARK: Private

  // swiftlint:disable all
  private var repository: CredentialRepositoryProtocolSpy!
  private var useCase: SaveCredentialUseCaseProtocol!
  // swiftlint:enable all

}

extension SaveCredentialUseCaseTests {
  private func makeCredentialWithKeyBinding() -> (credential: AnyCredential, keyPair: KeyPair?) {
    let anyCredential = AnyCredentialSpy()
    anyCredential.format = UUID().uuidString
    anyCredential.raw = UUID().uuidString
    anyCredential.issuer = "issuer"
    let anyClaim = AnyClaimSpy()
    anyClaim.key = "lastName" // must be a key existing in the metadataWrapper
    anyClaim.value = .string(UUID().uuidString)
    anyCredential.claims = [anyClaim]
    return (anyCredential, nil)
  }
}
