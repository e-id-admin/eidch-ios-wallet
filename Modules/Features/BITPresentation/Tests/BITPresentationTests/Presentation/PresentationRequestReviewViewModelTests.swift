import Factory
import XCTest

@testable import BITOpenID
@testable import BITPresentation
@testable import BITTestingCore

class PresentationRequestReviewViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    super.setUp()
    context = .Mock.vcSdJwtSample
    Container.shared.submitPresentationUseCase.register { self.submitPresentationUseCase }
    Container.shared.denyPresentationUseCase.register { self.denyPresentationUseCase }
    Container.shared.getVerifierDisplayUseCase.register { self.getVerifierDisplayUseCase }

    router = MockPresentationRouter()

    viewModel = PresentationRequestReviewViewModel(context: context, router: router)
  }

  @MainActor
  func testInitialStateWithoutVerifierDisplay_withoutTrustStatement() {
    viewModel = PresentationRequestReviewViewModel(context: context, router: router)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertEqual(viewModel.verifierDisplay?.trustStatus, .unverified)
    XCTAssertEqual(viewModel.verifierDisplay?.name, "Ref Test")
  }

  @MainActor
  func testInitialStateWithoutVerifierDisplay_withTrustStatement() {
    let mockContext: PresentationRequestContext = .Mock.vcSdJwtJwtSample
    getVerifierDisplayUseCase.executeForTrustStatementReturnValue = .Mock.sample

    viewModel = PresentationRequestReviewViewModel(context: mockContext, router: router)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertEqual(viewModel.verifierDisplay?.trustStatus, .verified)
    XCTAssertEqual(viewModel.verifierDisplay?.name, "Verifier")
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.trustStatement, mockContext.trustStatement)
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.verifier, mockContext.requestObject.clientMetadata)
  }

  @MainActor
  func testHappyPath() async throws {
    await viewModel.send(event: .submit)

    XCTAssertTrue(viewModel.isLoading)
    XCTAssertTrue(submitPresentationUseCase.executeContextCalled)
    XCTAssertEqual(submitPresentationUseCase.executeContextCallsCount, 1)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testFailurePath() async throws {
    submitPresentationUseCase.executeContextThrowableError = TestingError.error

    await viewModel.send(event: .submit)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertEqual(viewModel.state, .error)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertFalse(router.closeCalled)
    XCTAssertTrue(submitPresentationUseCase.executeContextCalled)
    XCTAssertEqual(submitPresentationUseCase.executeContextCallsCount, 1)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testDeny() async throws {
    await viewModel.send(event: .deny)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertTrue(router.closeCalled)
    XCTAssertTrue(denyPresentationUseCase.executeContextErrorCalled)
    XCTAssertEqual(denyPresentationUseCase.executeContextErrorCallsCount, 1)
    XCTAssertEqual(denyPresentationUseCase.executeContextErrorReceivedArguments?.error, .clientRejected)
  }

  @MainActor
  func testDeny_withError() async throws {
    denyPresentationUseCase.executeContextErrorThrowableError = TestingError.error

    await viewModel.send(event: .deny)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertTrue(router.closeCalled)
    XCTAssertTrue(denyPresentationUseCase.executeContextErrorCalled)
    XCTAssertEqual(denyPresentationUseCase.executeContextErrorCallsCount, 1)
    XCTAssertEqual(denyPresentationUseCase.executeContextErrorReceivedArguments?.error, .clientRejected)
  }

  @MainActor
  func testClose() async throws {
    await viewModel.send(event: .close)
    XCTAssertTrue(router.closeCalled)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(submitPresentationUseCase.executeContextCalled)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func test_presentationSubmit_suspendedCredential() async throws {
    submitPresentationUseCase.executeContextThrowableError = SubmitPresentationError.credentialInvalid

    await viewModel.send(event: .submit)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(router.closeCalled)
    XCTAssertEqual(viewModel.state, .invalidCredentialError)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertTrue(submitPresentationUseCase.executeContextCalled)
  }

  @MainActor
  func test_presentationSubmit_revokedCredential() async throws {
    submitPresentationUseCase.executeContextThrowableError = SubmitPresentationError.credentialInvalid

    await viewModel.send(event: .submit)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(router.closeCalled)
    XCTAssertEqual(viewModel.state, .invalidCredentialError)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertTrue(submitPresentationUseCase.executeContextCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: PresentationRequestReviewViewModel!
  private var context: PresentationRequestContext!
  private var submitPresentationUseCase = SubmitPresentationUseCaseProtocolSpy()
  private var denyPresentationUseCase = DenyPresentationUseCaseProtocolSpy()
  private var getVerifierDisplayUseCase = GetVerifierDisplayUseCaseProtocolSpy()
  private let selectedCredentialMock: CompatibleCredential = .Mock.BIT
  private var mockRequestObjectMock: RequestObject!
  private var router = MockPresentationRouter()
  // swiftlint:enable all
}
