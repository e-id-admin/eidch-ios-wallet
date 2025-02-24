import XCTest
@testable import BITEIDRequest

class CheckCardIntroductionViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    router = MockEIDRequestRouter()
    viewModel = CheckCardIntroductionViewModel(router: router, cameraPermission: .authorized)
  }

  func testClose() {
    viewModel.close()
    XCTAssertTrue(router.closeCalled)
  }

  @MainActor
  func testOpenScannerWithCameraPermission() {
    viewModel = CheckCardIntroductionViewModel(router: router, cameraPermission: .authorized)
    viewModel.primaryAction()
    XCTAssertTrue(router.mrzScannerCalled)
  }

  @MainActor
  func testOpenScannerWithoutCameraPermission() {
    viewModel = CheckCardIntroductionViewModel(router: router, cameraPermission: .notDetermined)
    viewModel.primaryAction()
    XCTAssertTrue(router.cameraPermissionCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var router: MockEIDRequestRouter!
  private var viewModel: CheckCardIntroductionViewModel!
  // swiftlint:enable all

}
