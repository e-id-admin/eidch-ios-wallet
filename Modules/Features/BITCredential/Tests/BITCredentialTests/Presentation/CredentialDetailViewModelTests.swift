import Factory
import XCTest
@testable import BITCredential
@testable import BITCredentialShared
@testable import BITTestingCore

final class CredentialDetailViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    Container.shared.deleteCredentialUseCase.register { self.deleteCredentialUseCase }
    Container.shared.checkAndUpdateCredentialStatusUseCase.register { self.checkAndUpdateCredentialStatusUseCaseSpy }

    viewModel = CredentialDetailViewModel(credential, router: mockRouter)
  }

  @MainActor
  func test_init() {
    XCTAssertFalse(viewModel.isDeleteCredentialAlertPresented)

    XCTAssertEqual(viewModel.credential, credential)
    XCTAssertEqual(viewModel.credentialBody, CredentialDetailBody(from: credential))
  }

  @MainActor
  func test_onAppear() async {
    checkAndUpdateCredentialStatusUseCaseSpy.executeForReturnValue = credential

    await viewModel.onAppear()

    XCTAssertTrue(checkAndUpdateCredentialStatusUseCaseSpy.executeForCalled)
    XCTAssertNotNil(viewModel.credentialBody)
    XCTAssertEqual(viewModel.credentialBody, CredentialDetailBody(from: credential))
  }

  @MainActor
  func test_onRefresh() async {
    checkAndUpdateCredentialStatusUseCaseSpy.executeForReturnValue = credential

    await viewModel.refresh()

    XCTAssertTrue(checkAndUpdateCredentialStatusUseCaseSpy.executeForCalled)
    XCTAssertNotNil(viewModel.credentialBody)
    XCTAssertEqual(viewModel.credentialBody, CredentialDetailBody(from: credential))
  }

  @MainActor
  func test_openWrongData() {
    viewModel.openWrongdata()

    XCTAssertTrue(mockRouter.didCallWrongData)
  }

  @MainActor
  func test_close() {
    viewModel.close()

    XCTAssertTrue(mockRouter.closeCalled)
  }

  @MainActor
  func test_delete_success() async {
    deleteCredentialUseCase.executeClosure = { _ in }

    await viewModel.deleteCredential()

    XCTAssertTrue(deleteCredentialUseCase.executeCalled)
    XCTAssertTrue(mockRouter.closeCalled)
  }

  @MainActor
  func test_delete_failure() async {
    deleteCredentialUseCase.executeThrowableError = TestingError.error

    await viewModel.deleteCredential()

    XCTAssertTrue(deleteCredentialUseCase.executeCalled)
    XCTAssertFalse(mockRouter.closeCalled)
  }

  @MainActor
  func testWillResignActive() async {
    viewModel.isDeleteCredentialAlertPresented = true

    NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil, userInfo: nil)

    try? await Task.sleep(nanoseconds: 200_000_000)
    XCTAssertFalse(viewModel.isDeleteCredentialAlertPresented)
  }

  // MARK: Private

  // swiftlint:disable all
  private let credential = Credential.Mock.sample
  private var mockRouter = CredentialDetailRouterMock()
  private var viewModel: CredentialDetailViewModel!
  private var deleteCredentialUseCase = DeleteCredentialUseCaseProtocolSpy()
  private var checkAndUpdateCredentialStatusUseCaseSpy = CheckAndUpdateCredentialStatusUseCaseProtocolSpy()
  // swiftlint:enable all

}
