import XCTest
@testable import BITEIDRequest

class WalletPairingViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    router = MockEIDRequestRouter()
    viewModel = WalletPairingViewModel(router: router)
  }

  func testPrimaryAction() {
    viewModel.primaryAction()
    XCTAssertTrue(router.closeCalled)
  }

  func testClose() {
    viewModel.close()
    XCTAssertTrue(router.closeCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var router: MockEIDRequestRouter!
  private var viewModel: WalletPairingViewModel!
  // swiftlint:enable all

}
