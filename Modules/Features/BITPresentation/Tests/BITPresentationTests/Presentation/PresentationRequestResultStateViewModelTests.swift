import Factory
import XCTest
@testable import BITOpenID
@testable import BITPresentation
@testable import BITTestingCore

class PresentationRequestResultStateViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    context = .Mock.vcSdJwtSample
    Container.shared.reset()
    Container.shared.getVerifierDisplayUseCase.register { self.getVerifierDisplayUseCase }
    router = MockPresentationRouter()

    viewModel = PresentationRequestResultStateViewModel(state: .error, context: context, router: router)
  }

  @MainActor
  func testInitialStateWithoutVerifierDisplay_withoutTrustStatement() {
    viewModel = PresentationRequestResultStateViewModel(state: .error, context: context, router: router)

    XCTAssertEqual(viewModel.verifierDisplay?.trustStatus, .unverified)
    XCTAssertEqual(viewModel.verifierDisplay?.name, "EN Verifier")
  }

  @MainActor
  func testInitialStateWithoutVerifierDisplay_withTrustStatement() {
    let mockContext = PresentationRequestContext.Mock.vcSdJwtJwtSample
    getVerifierDisplayUseCase.executeForTrustStatementReturnValue = .Mock.sample

    viewModel = PresentationRequestResultStateViewModel(state: .error, context: mockContext, router: router)

    XCTAssertEqual(viewModel.verifierDisplay?.trustStatus, .verified)
    XCTAssertEqual(viewModel.verifierDisplay?.name, "Verifier")
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.trustStatement, mockContext.trustStatement)
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.verifier, mockContext.requestObject.clientMetadata)
  }

  @MainActor
  func testClose_CloseCalled() async throws {
    viewModel.close()

    XCTAssertTrue(router.closeCalled)
  }

  @MainActor
  func testRetry_PopCalled() async throws {
    viewModel.retry()

    XCTAssertTrue(router.popCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: PresentationRequestResultStateViewModel!
  private var context: PresentationRequestContext!
  private var getVerifierDisplayUseCase = GetVerifierDisplayUseCaseProtocolSpy()
  private var router = MockPresentationRouter()
  // swiftlint:enable all
}
