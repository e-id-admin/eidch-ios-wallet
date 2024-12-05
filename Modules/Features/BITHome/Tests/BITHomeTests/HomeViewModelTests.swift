import Factory
import XCTest

@testable import BITAppAuth
@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITHome
@testable import BITTestingCore

final class HomeViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    getCredentialListUseCase = GetCredentialListUseCaseProtocolSpy()
    checkAndUpdateCredentialStatusUseCase = CheckAndUpdateCredentialStatusUseCaseProtocolSpy()
    isUserLoggedInUseCase = IsUserLoggedInUseCaseProtocolSpy()
    isUserLoggedInUseCase.executeReturnValue = true
    mockRouter = HomeRouterMock()

    viewModel = HomeViewModel(
      router: mockRouter,
      getCredentialListUseCase: getCredentialListUseCase,
      checkAndUpdateCredentialStatusUseCase: checkAndUpdateCredentialStatusUseCase,
      isUserLoggedInUseCase: isUserLoggedInUseCase)
  }

  @MainActor
  func testInitialValues() {
    XCTAssertFalse(viewModel.isImpressumPresented)
    XCTAssertFalse(viewModel.isSecurityPresented)
    XCTAssertFalse(viewModel.isLicensesPresented)
    XCTAssertFalse(viewModel.isVerificationInstructionPresented)
    XCTAssertEqual(viewModel.state, .results)
  }

  @MainActor
  func testLoadCredential_happyPath() async {
    getCredentialListUseCase.executeReturnValue = Credential.Mock.array

    await viewModel.send(event: .fetchCredentials)
    XCTAssertEqual(viewModel.credentials, Credential.Mock.array)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .results)
  }

  @MainActor
  func testLoadCredential_emptyPath() async {
    getCredentialListUseCase.executeReturnValue = []
    await viewModel.send(event: .fetchCredentials)
    XCTAssertEqual(viewModel.credentials, [])

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .empty)
  }

  @MainActor
  func testRefresh() async {
    await testLoadCredential_emptyPath()
    getCredentialListUseCase.executeReturnValue = Credential.Mock.array
    XCTAssertFalse(getCredentialListUseCase.executeReturnValue.isEmpty)
    await viewModel.send(event: .refresh)

    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 2)
    XCTAssertEqual(viewModel.state, .results)
  }

  @MainActor
  func testRefreshWithUserLoggedOut_andNoCredential() async {
    await testLoadCredential_emptyPath()

    isUserLoggedInUseCase.executeReturnValue = false
    getCredentialListUseCase.executeReturnValue = Credential.Mock.array
    XCTAssertFalse(getCredentialListUseCase.executeReturnValue.isEmpty)
    await viewModel.send(event: .refresh)

    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .empty)
  }

  @MainActor
  func testRefreshWithUserLoggedOut_withCredentials() async {
    await testLoadCredential_happyPath()

    isUserLoggedInUseCase.executeReturnValue = false
    getCredentialListUseCase.executeReturnValue = Credential.Mock.array
    XCTAssertFalse(getCredentialListUseCase.executeReturnValue.isEmpty)
    await viewModel.send(event: .refresh)

    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .results)
  }

  @MainActor
  func testRefresh_fetchHappyPath_thenFailurePath() async {
    await testLoadCredential_happyPath()
    getCredentialListUseCase.executeThrowableError = TestingError.error
    await viewModel.send(event: .refresh)

    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 2)
    XCTAssertEqual(viewModel.state, .results)
  }

  @MainActor
  func testRefresh_fetchEmpty_thenFailurePath() async {
    await testLoadCredential_emptyPath()
    getCredentialListUseCase.executeThrowableError = TestingError.error
    await viewModel.send(event: .refresh)

    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 2)
    XCTAssertEqual(viewModel.state, .error)
  }

  @MainActor
  func testLoadCredential_failurePath() async {
    getCredentialListUseCase.executeThrowableError = TestingError.error
    await viewModel.send(event: .fetchCredentials)
    XCTAssertEqual(viewModel.credentials, [])

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .error)
  }

  @MainActor
  func testGetHasDeletedCredentialWithDeletedCredential_Success() async {
    getCredentialListUseCase.executeReturnValue = []
    await viewModel.send(event: .fetchCredentials)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .empty)
  }

  @MainActor
  func testGetHasDeletedCredentialWithNoDeletedCredential_Success() async {
    getCredentialListUseCase.executeReturnValue = []
    await viewModel.send(event: .fetchCredentials)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .empty)
  }

  @MainActor
  func testCheckAllCredentialsStatus_Success() async throws {
    getCredentialListUseCase.executeReturnValue = mockCrendentials
    checkAndUpdateCredentialStatusUseCase.executeReturnValue = mockCrendentials

    await viewModel.send(event: .checkCredentialsStatus)

    XCTAssertEqual(viewModel.state, .results)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeCalled)
    XCTAssertEqual(checkAndUpdateCredentialStatusUseCase.executeReturnValue.count, mockCrendentials.count)
  }

  @MainActor
  func testCheckAllCredentialsStatus_userLoggedOut() async throws {
    getCredentialListUseCase.executeReturnValue = mockCrendentials
    checkAndUpdateCredentialStatusUseCase.executeReturnValue = mockCrendentials

    isUserLoggedInUseCase.executeReturnValue = false

    await viewModel.send(event: .checkCredentialsStatus)

    XCTAssertEqual(viewModel.state, .results)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeCalled)
  }

  @MainActor
  func testCheckAllCredentialsStatus_failure() async throws {
    getCredentialListUseCase.executeReturnValue = mockCrendentials
    checkAndUpdateCredentialStatusUseCase.executeThrowableError = TestingError.error

    await viewModel.send(event: .checkCredentialsStatus)

    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.stateError)
  }

  @MainActor
  func testOpenScanner() {
    viewModel.openScanner()

    XCTAssertTrue(mockRouter.didCallInvitation)
  }

  @MainActor
  func testOpenSettings() {
    viewModel.openSettings()

    XCTAssertTrue(mockRouter.didCallSettings)
  }

  @MainActor
  func testOpenHelp() {
    viewModel.openHelp()

    XCTAssertTrue(mockRouter.didCallExternalLinkUrl)
  }

  @MainActor
  func testOpenContact() {
    viewModel.openContact()

    XCTAssertTrue(mockRouter.didCallExternalLinkUrl)
  }

  @MainActor
  func testOpenImpressum() {
    viewModel.openImpressum()

    XCTAssertTrue(viewModel.isImpressumPresented)
  }

  @MainActor
  func testOpenLicenses() {
    viewModel.openLicenses()

    XCTAssertTrue(viewModel.isLicensesPresented)
  }

  @MainActor
  func testOpenSecurity() {
    viewModel.openSecurity()

    XCTAssertTrue(viewModel.isSecurityPresented)
  }

  @MainActor
  func testOpenCredentialDetai() {
    viewModel.openDetail(for: .Mock.sample)

    XCTAssertTrue(mockRouter.didCallOpenCredentialDetail)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockCrendentials = Credential.Mock.array
  private var getCredentialListUseCase: GetCredentialListUseCaseProtocolSpy!
  private var checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocolSpy!
  private var isUserLoggedInUseCase: IsUserLoggedInUseCaseProtocolSpy!
  private var viewModel: HomeViewModel!
  private var mockRouter: HomeRouterMock!
  // swiftlint:enable all

}
