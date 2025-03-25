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

// MARK: - FetchCredentialUseCaseTests

final class FetchCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    fetchAnyVerifiableCredentialUseCase = FetchAnyVerifiableCredentialUseCaseProtocolSpy()
    saveCredentialUseCase = SaveCredentialUseCaseProtocolSpy()
    checkAndUpdateCredentialStatusUseCase = CheckAndUpdateCredentialStatusUseCaseProtocolSpy()

    Container.shared.fetchAnyVerifiableCredentialUseCase.register { self.fetchAnyVerifiableCredentialUseCase }
    Container.shared.saveCredentialUseCase.register { self.saveCredentialUseCase }
    Container.shared.checkAndUpdateCredentialStatusUseCase.register { self.checkAndUpdateCredentialStatusUseCase }

    useCase = FetchCredentialUseCase()
  }

  func testHappyPath() async throws {
    fetchAnyVerifiableCredentialUseCase.executeFromReturnValue = (metadataWrapper, anyCredential, nil)
    saveCredentialUseCase.executeCredentialKeyPairMetadataWrapperReturnValue = credential
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = credential

    let result = try await useCase.execute(from: offer)
    XCTAssertEqual(result, credential)

    XCTAssertTrue(fetchAnyVerifiableCredentialUseCase.executeFromCalled)
    XCTAssertEqual(fetchAnyVerifiableCredentialUseCase.executeFromCallsCount, 1)
    XCTAssertTrue(saveCredentialUseCase.executeCredentialKeyPairMetadataWrapperCalled)
    XCTAssertEqual(saveCredentialUseCase.executeCredentialKeyPairMetadataWrapperCallsCount, 1)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(checkAndUpdateCredentialStatusUseCase.executeForCallsCount, 1)
  }

  func test_fetchCredentialFailure() async throws {
    fetchAnyVerifiableCredentialUseCase.executeFromThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(from: offer)
      XCTFail("Expected a TestingError.error instead")
    } catch TestingError.error {
      XCTAssertTrue(fetchAnyVerifiableCredentialUseCase.executeFromCalled)
      XCTAssertEqual(fetchAnyVerifiableCredentialUseCase.executeFromCallsCount, 1)
      XCTAssertFalse(saveCredentialUseCase.executeCredentialKeyPairMetadataWrapperCalled)
      XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    } catch {
      XCTFail("Expected another error")
    }
  }

  func test_saveFailure() async throws {
    fetchAnyVerifiableCredentialUseCase.executeFromReturnValue = (metadataWrapper, anyCredential, nil)
    saveCredentialUseCase.executeCredentialKeyPairMetadataWrapperThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(from: offer)
      XCTFail("Expected a TestingError.error instead")
    } catch TestingError.error {
      XCTAssertTrue(fetchAnyVerifiableCredentialUseCase.executeFromCalled)
      XCTAssertEqual(fetchAnyVerifiableCredentialUseCase.executeFromCallsCount, 1)
      XCTAssertTrue(saveCredentialUseCase.executeCredentialKeyPairMetadataWrapperCalled)
      XCTAssertEqual(saveCredentialUseCase.executeCredentialKeyPairMetadataWrapperCallsCount, 1)
      XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    } catch {
      XCTFail("Expected another error")
    }
  }

  func test_checkAndUpdateStatusFailure() async throws {
    fetchAnyVerifiableCredentialUseCase.executeFromReturnValue = (metadataWrapper, anyCredential, nil)
    saveCredentialUseCase.executeCredentialKeyPairMetadataWrapperReturnValue = credential
    checkAndUpdateCredentialStatusUseCase.executeForThrowableError = TestingError.error

    let result = try await useCase.execute(from: offer)
    XCTAssertEqual(result, credential)
    XCTAssertTrue(fetchAnyVerifiableCredentialUseCase.executeFromCalled)
    XCTAssertEqual(fetchAnyVerifiableCredentialUseCase.executeFromCallsCount, 1)
    XCTAssertTrue(saveCredentialUseCase.executeCredentialKeyPairMetadataWrapperCalled)
    XCTAssertEqual(saveCredentialUseCase.executeCredentialKeyPairMetadataWrapperCallsCount, 1)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(checkAndUpdateCredentialStatusUseCase.executeForCallsCount, 1)
  }

  // MARK: Private

  // swiftlint:disable all
  private var fetchAnyVerifiableCredentialUseCase: FetchAnyVerifiableCredentialUseCaseProtocolSpy!
  private var saveCredentialUseCase: SaveCredentialUseCaseProtocolSpy!
  private var checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocolSpy!
  private var useCase: FetchCredentialUseCase!
  // swiftlint:enable all

  private let credential: Credential = .Mock.sample
  private let metadataWrapper: CredentialMetadataWrapper = .Mock.sample
  private let anyCredential: AnyCredential = MockAnyCredential()
  private let offer: CredentialOffer = .Mock.sample

}
