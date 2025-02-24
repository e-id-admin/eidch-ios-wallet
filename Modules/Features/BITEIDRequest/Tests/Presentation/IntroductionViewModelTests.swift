import XCTest
@testable import BITEIDRequest

class IntroductionViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    router = MockEIDRequestRouter()
    viewModel = IntroductionViewModel(router: router)
  }

  func testClose() {
    viewModel.close()
    XCTAssertTrue(router.closeCalled)
  }

  func testOpenCheckCard() {
    viewModel.openDataPrivacy()
    XCTAssertTrue(router.dataPrivacyCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var router: MockEIDRequestRouter!
  private var viewModel: IntroductionViewModel!
  // swiftlint:enable all

}
