import Factory
import Spyable
import XCTest
@testable import BITEIDRequest
@testable import BITTestingCore

final class SubmitEIDRequestUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    repository = EIDRequestRepositoryProtocolSpy()
    localRepository = LocalEIDRequestRepositoryProtocolSpy()

    Container.shared.eIDRequestRepository.register { self.repository }
    Container.shared.localEIDRequestRepository.register { self.localRepository }

    useCase = SubmitEIDRequestUseCase()
  }

  func testHappyPath() async throws {
    guard let payload: EIDRequestPayload = MRZData.Mock.array.first?.payload else {
      fatalError("Failed to create mock EIDRequestPayload")
    }

    repository.submitRequestWithReturnValue = mockEIDRequestResponse
    repository.fetchRequestStatusForReturnValue = mockEIDRequestStatus
    localRepository.createEIDRequestCaseReturnValue = mockEIDRequestCase

    let result = try await useCase.execute(payload)

    XCTAssertEqual(repository.submitRequestWithReceivedPayload, payload)
    XCTAssertEqual(repository.fetchRequestStatusForReceivedCaseId, mockEIDRequestResponse.caseId)
    XCTAssertEqual(localRepository.createEIDRequestCaseReceivedEIDRequestCase?.id, mockEIDRequestResponse.caseId)
    XCTAssertNotNil(localRepository.createEIDRequestCaseReceivedEIDRequestCase?.state)
    XCTAssertEqual(result, mockEIDRequestCase)
  }

  func testFailure() async throws {
    guard let payload: EIDRequestPayload = MRZData.Mock.array.first?.payload else {
      fatalError("Failed to create mock EIDRequestPayload")
    }

    repository.submitRequestWithThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(payload)
    } catch TestingError.error {
      XCTAssertEqual(repository.submitRequestWithReceivedPayload, payload)
    } catch {
      XCTFail("Unexpected error")
    }
  }

  func testGetStatus_Failure() async throws {
    guard let payload: EIDRequestPayload = MRZData.Mock.array.first?.payload else {
      fatalError("Failed to create mock EIDRequestPayload")
    }

    repository.submitRequestWithReturnValue = mockEIDRequestResponse
    repository.fetchRequestStatusForThrowableError = TestingError.error
    localRepository.createEIDRequestCaseReturnValue = mockEIDRequestCaseWithoutState

    do {
      _ = try await useCase.execute(payload)
    } catch TestingError.error {
      XCTAssertEqual(repository.submitRequestWithReceivedPayload, payload)
      XCTAssertEqual(repository.fetchRequestStatusForReceivedCaseId, mockEIDRequestResponse.caseId)
      XCTAssertEqual(localRepository.createEIDRequestCaseReceivedEIDRequestCase, mockEIDRequestCaseWithoutState)
      XCTAssertNil(localRepository.createEIDRequestCaseReceivedEIDRequestCase?.state)
    } catch {
      XCTFail("Unexpected error")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockEIDRequestResponse: EIDRequestResponse = .Mock.sample
  private let mockEIDRequestStatus: EIDRequestStatus = .Mock.inQueueSample
  private let mockEIDRequestCase: EIDRequestCase = .Mock.sampleWithoutState
  private let mockEIDRequestCaseWithoutState: EIDRequestCase = .Mock.sampleWithoutState
  private var repository: EIDRequestRepositoryProtocolSpy!
  private var useCase: SubmitEIDRequestUseCase!
  private var localRepository: LocalEIDRequestRepositoryProtocolSpy!
  // swiftlint:enable all

}
