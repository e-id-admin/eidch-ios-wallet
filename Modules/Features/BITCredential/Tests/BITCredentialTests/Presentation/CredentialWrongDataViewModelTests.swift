import XCTest

@testable import BITCredential

final class CredentialWrongDataViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    router = CredentialWrongDataRouterMock()
    viewModel = CredentialWrongDataViewModel(router: router)
  }

  func testOpenInformations() {
    viewModel.openInformations()
    XCTAssertTrue(router.didCallExternalLink)
  }

  func testClose() {
    viewModel.close()
    XCTAssertTrue(router.closeCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: CredentialWrongDataViewModel!
  private var router: CredentialWrongDataRouterMock!
  // swiftlint:enable all

}
