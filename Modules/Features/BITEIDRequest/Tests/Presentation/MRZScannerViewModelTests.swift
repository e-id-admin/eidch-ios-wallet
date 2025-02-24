import Factory
import XCTest
@testable import BITEIDRequest
@testable import BITTestingCore

@MainActor
class MRZScannerViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    router = MockEIDRequestRouter()
    submitEIDRequestUseCase = SubmitEIDRequestUseCaseProtocolSpy()

    Container.shared.submitEIDRequestUseCase.register { self.submitEIDRequestUseCase }

    viewModel = MRZScannerViewModel(router: router)
  }

  func testInitialState() {
    XCTAssertFalse(viewModel.isErrorPresented)
    XCTAssertNil(viewModel.errorDescription)
  }

  func testSubmit_InQueueState_success() async throws {
    guard let payload: EIDRequestPayload = MRZData.Mock.array.first?.payload else {
      fatalError("Failed to create mock EIDRequestPayload")
    }

    let mockEIDRequestCase: EIDRequestCase = .Mock.sampleInQueue

    submitEIDRequestUseCase.executeReturnValue = mockEIDRequestCase

    await viewModel.submit(payload)

    XCTAssertEqual(submitEIDRequestUseCase.executeReceivedPayload, payload)
    XCTAssertEqual(router.queueInformationArgument, mockEIDRequestCase.state?.onlineSessionStartOpenAt)
    XCTAssertFalse(viewModel.isErrorPresented)
    XCTAssertNil(viewModel.errorDescription)
  }

  func testSubmit_ReadyState_success() async throws {
    guard let payload: EIDRequestPayload = MRZData.Mock.array.first?.payload else {
      fatalError("Failed to create mock EIDRequestPayload")
    }

    let mockEIDRequestCase: EIDRequestCase = .Mock.sampleAVReady

    submitEIDRequestUseCase.executeReturnValue = mockEIDRequestCase

    await viewModel.submit(payload)

    XCTAssertEqual(submitEIDRequestUseCase.executeReceivedPayload, payload)
    XCTAssertTrue(router.closeCalled)
    XCTAssertFalse(viewModel.isErrorPresented)
    XCTAssertNil(viewModel.errorDescription)
  }

  func testSubmit_NoRequestState() async throws {
    guard let payload: EIDRequestPayload = MRZData.Mock.array.first?.payload else {
      fatalError("Failed to create mock EIDRequestPayload")
    }

    let mockEIDRequestCase: EIDRequestCase = .Mock.sampleWithoutState

    submitEIDRequestUseCase.executeReturnValue = mockEIDRequestCase

    await viewModel.submit(payload)

    XCTAssertEqual(submitEIDRequestUseCase.executeReceivedPayload, payload)
    XCTAssertTrue(router.closeCalled)
    XCTAssertFalse(viewModel.isErrorPresented)
    XCTAssertNil(viewModel.errorDescription)
  }

  func testSubmit_InQueue_WithoutOnlineSessionStartOpenAt() async throws {
    guard let payload: EIDRequestPayload = MRZData.Mock.array.first?.payload else {
      fatalError("Failed to create mock EIDRequestPayload")
    }

    let mockEIDRequestCase: EIDRequestCase = .Mock.sampleInQueueNoOnlineSessionStart

    submitEIDRequestUseCase.executeReturnValue = mockEIDRequestCase

    await viewModel.submit(payload)

    XCTAssertEqual(submitEIDRequestUseCase.executeReceivedPayload, payload)
    XCTAssertTrue(router.closeCalled)
    XCTAssertFalse(viewModel.isErrorPresented)
    XCTAssertNil(viewModel.errorDescription)
  }

  func testSubmit_error() async throws {
    guard let payload: EIDRequestPayload = MRZData.Mock.array.first?.payload else {
      fatalError("Failed to create mock EIDRequestPayload")
    }

    submitEIDRequestUseCase.executeThrowableError = TestingError.error

    await viewModel.submit(payload)

    XCTAssertNil(router.queueInformationArgument)
    XCTAssertTrue(viewModel.isErrorPresented)
    XCTAssertNotNil(viewModel.errorDescription)
  }

  @MainActor
  func testClose() {
    viewModel.close()
    XCTAssertTrue(router.closeCalled)
  }

  func testResetError() {
    XCTAssertFalse(viewModel.isErrorPresented)
    XCTAssertNil(viewModel.errorDescription)
  }

  // MARK: Private

  // swiftlint:disable all
  private var router: MockEIDRequestRouter!
  private var viewModel: MRZScannerViewModel!
  private var submitEIDRequestUseCase: SubmitEIDRequestUseCaseProtocolSpy!
  // swiftlint:enable all

}
