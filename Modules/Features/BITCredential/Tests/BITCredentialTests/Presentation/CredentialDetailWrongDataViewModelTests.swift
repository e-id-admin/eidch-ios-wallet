import XCTest
@testable import BITCredential

final class CredentialDetailWrongDataViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    router = CredentialDetailRouterMock()
    viewModel = CredentialDetailWrongDataViewModel(router: router)
  }

  func testClose() {
    viewModel.close()
    XCTAssertTrue(router.closeCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: CredentialDetailWrongDataViewModel!
  private var router: CredentialDetailRouterMock!
  // swiftlint:enable all

}
