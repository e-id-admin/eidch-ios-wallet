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
    getVerifierDisplayUseCase.executeForTrustStatementReturnValue = mockUnTrustedVerifierDisplay
    viewModel = PresentationRequestResultStateViewModel(state: .error, context: context, router: router)
    XCTAssertEqual(viewModel.verifierDisplay, mockUnTrustedVerifierDisplay)
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.trustStatement, context.trustStatement)
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.verifier, context.requestObject.clientMetadata)
  }

  @MainActor
  func testInitialStateWithoutVerifierDisplay_withTrustStatement() {
    getVerifierDisplayUseCase.executeForTrustStatementReturnValue = mockTrustedVerifierDisplay
    viewModel = PresentationRequestResultStateViewModel(state: .error, context: context, router: router)

    XCTAssertEqual(viewModel.verifierDisplay, mockTrustedVerifierDisplay)
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.trustStatement, context.trustStatement)
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.verifier, context.requestObject.clientMetadata)
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
  private var mockTrustedVerifierDisplay = VerifierDisplay(name: "name", logo: Data(), trustStatus: .verified)
  private var mockUnTrustedVerifierDisplay = VerifierDisplay(name: "name", logo: Data(), trustStatus: .unverified)
  // swiftlint:enable all
}
