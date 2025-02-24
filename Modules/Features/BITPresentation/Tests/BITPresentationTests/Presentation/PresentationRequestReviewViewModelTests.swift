import Factory
import XCTest
@testable import BITOpenID
@testable import BITPresentation
@testable import BITTestingCore

class PresentationRequestReviewViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    context = .Mock.vcSdJwtSample

    Container.shared.reset()
    Container.shared.submitPresentationUseCase.register { self.submitPresentationUseCase }
    Container.shared.denyPresentationUseCase.register { self.denyPresentationUseCase }
    Container.shared.getVerifierDisplayUseCase.register { self.getVerifierDisplayUseCase }

    router = MockPresentationRouter()

    viewModel = PresentationRequestReviewViewModel(context: context, router: router)
  }

  @MainActor
  func testInitialStateWithoutVerifierDisplay_withoutTrustStatement() {
    viewModel = PresentationRequestReviewViewModel(context: context, router: router)

    XCTAssertFalse(viewModel.showLoadingMessage)
    XCTAssertEqual(viewModel.verifierDisplay?.trustStatus, .unverified)
    XCTAssertEqual(viewModel.verifierDisplay?.name, "EN Verifier")
  }

  @MainActor
  func testInitialStateWithoutVerifierDisplay_withTrustStatement() {
    let mockContext = PresentationRequestContext.Mock.vcSdJwtJwtSample
    getVerifierDisplayUseCase.executeForTrustStatementReturnValue = .Mock.sample

    viewModel = PresentationRequestReviewViewModel(context: mockContext, router: router)

    XCTAssertFalse(viewModel.showLoadingMessage)
    XCTAssertEqual(viewModel.verifierDisplay?.trustStatus, .verified)
    XCTAssertEqual(viewModel.verifierDisplay?.name, "Verifier")
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.trustStatement, mockContext.trustStatement)
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.verifier, mockContext.requestObject.clientMetadata)
  }

  @MainActor
  func testSubmitPresentation_Success_NavigateToSuccess() async throws {
    await viewModel.submit()

    XCTAssertEqual(viewModel.state, .loading)
    XCTAssertFalse(viewModel.showLoadingMessage)
    XCTAssertTrue(submitPresentationUseCase.executeContextCalled)
    XCTAssertEqual(router.calledPresentationResultState, .success(claims: viewModel.credential.requestedClaims))
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testSubmitPresentation_ErrorThrown_ErrorState() async throws {
    submitPresentationUseCase.executeContextThrowableError = TestingError.error

    await viewModel.submit()

    XCTAssertEqual(viewModel.state, .result)
    XCTAssertFalse(viewModel.showLoadingMessage)
    XCTAssertEqual(router.calledPresentationResultState, .error)
    XCTAssertTrue(submitPresentationUseCase.executeContextCalled)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testSubmitPresentation_CredentialInvalid_ErrorState() async throws {
    submitPresentationUseCase.executeContextThrowableError = PresentationError.credentialInvalid

    await viewModel.submit()

    XCTAssertEqual(viewModel.state, .result)
    XCTAssertFalse(viewModel.showLoadingMessage)
    XCTAssertEqual(router.calledPresentationResultState, .error)
    XCTAssertTrue(submitPresentationUseCase.executeContextCalled)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testSubmitPresentation_PresentationCancelled_PresentationCancelledState() async throws {
    submitPresentationUseCase.executeContextThrowableError = PresentationError.presentationCancelled

    await viewModel.submit()

    XCTAssertEqual(viewModel.state, .result)
    XCTAssertFalse(viewModel.showLoadingMessage)
    XCTAssertEqual(router.calledPresentationResultState, .cancelled)
    XCTAssertTrue(submitPresentationUseCase.executeContextCalled)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testDeny() async throws {
    await viewModel.deny()
    try await viewModel.denyTask?.value

    XCTAssertFalse(viewModel.showLoadingMessage)
    XCTAssertEqual(router.calledPresentationResultState, .deny)
    XCTAssertTrue(denyPresentationUseCase.executeContextErrorCalled)
    XCTAssertEqual(denyPresentationUseCase.executeContextErrorReceivedArguments?.error, .clientRejected)
    XCTAssertFalse(submitPresentationUseCase.executeContextCalled)
  }

  @MainActor
  func testDeny_withError() async throws {
    denyPresentationUseCase.executeContextErrorThrowableError = TestingError.error

    await viewModel.deny()
    try await viewModel.denyTask?.value

    XCTAssertFalse(viewModel.showLoadingMessage)
    XCTAssertEqual(router.calledPresentationResultState, .deny)
    XCTAssertTrue(denyPresentationUseCase.executeContextErrorCalled)
    XCTAssertEqual(denyPresentationUseCase.executeContextErrorReceivedArguments?.error, .clientRejected)
    XCTAssertFalse(submitPresentationUseCase.executeContextCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: PresentationRequestReviewViewModel!
  private var context: PresentationRequestContext!
  private var submitPresentationUseCase = SubmitPresentationUseCaseProtocolSpy()
  private var denyPresentationUseCase = DenyPresentationUseCaseProtocolSpy()
  private var getVerifierDisplayUseCase = GetVerifierDisplayUseCaseProtocolSpy()
  private var router = MockPresentationRouter()
  // swiftlint:enable all
}
