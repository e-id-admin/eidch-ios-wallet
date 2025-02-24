import XCTest
@testable import BITEIDRequest

class DataPrivacyViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    router = MockEIDRequestRouter()
    viewModel = DataPrivacyViewModel(router: router)
  }

  @MainActor
  func testClose() {
    viewModel.close()
    XCTAssertTrue(router.closeCalled)
  }

  @MainActor
  func testOpenCheckCardIntroduction() {
    viewModel.openCheckCardIntroduction()
    XCTAssertTrue(router.checkCardIntroductionCalled)
  }

  @MainActor
  func testOpenHelp() {
    viewModel.openHelp()
    XCTAssertTrue(router.externalLinkCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var router: MockEIDRequestRouter!
  private var viewModel: DataPrivacyViewModel!
  // swiftlint:enable all

}
