import Factory
import XCTest
@testable import BITEIDRequest
@testable import BITTestingCore

final class GetEIDRequestCaseListUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = LocalEIDRequestRepositoryProtocolSpy()

    Container.shared.localEIDRequestRepository.register { self.repository }

    useCase = GetEIDRequestCaseListUseCase()
  }

  func testExecuteSucces() async throws {
    Container.shared.requestCasePriorityOrder.register { [.readyForOnlineSession, .inQueue] }
    repository.getAllReturnValue = mockEIDRequestCases

    let sortedArray: [EIDRequestCase] = [
      .Mock.sampleAVReady,
      .Mock.sampleInQueue,
      .Mock.sampleInQueueNoOnlineSessionStart,
      .Mock.sampleWithoutState,
    ]

    let requestCases = try await useCase.execute()

    XCTAssertEqual(requestCases, sortedArray)
    XCTAssertEqual(requestCases.count, mockEIDRequestCases.count)
  }

  func testExecuteSucces_withoutPriorities() async throws {
    Container.shared.requestCasePriorityOrder.register { [] }
    repository.getAllReturnValue = mockEIDRequestCases

    let requestCases = try await useCase.execute()

    XCTAssertEqual(requestCases.count, mockEIDRequestCases.count)
  }

  func testExecuteWithRepositoryError() async throws {
    repository.getAllThrowableError = TestingError.error

    do {
      _ = try await useCase.execute()
      XCTFail("An error was expected")
    } catch {
      XCTAssertTrue(repository.getAllCalled)
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: GetEIDRequestCaseListUseCase!
  private var mockEIDRequestCases: [EIDRequestCase] = [.Mock.sampleAVReady, .Mock.sampleInQueue, .Mock.sampleInQueueNoOnlineSessionStart, .Mock.sampleWithoutState]
  private var repository: LocalEIDRequestRepositoryProtocolSpy!
  // swiftlint:enable all

}
