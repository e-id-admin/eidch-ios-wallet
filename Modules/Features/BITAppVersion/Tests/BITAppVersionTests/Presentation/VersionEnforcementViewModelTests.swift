import XCTest

@testable import BITAppVersion

final class VersionEnforcementViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    mockRouter = VersionEnforcementRouterMock()

    viewModel = .init(router: mockRouter, versionEnforcement: mockVersionEnforcement)
  }

  func testInitialState() {
    XCTAssertFalse(viewModel.title.isEmpty)
    XCTAssertFalse(viewModel.content.isEmpty)
  }

  func testVersionEnforcementWithoutDisplay() {
    viewModel = .init(versionEnforcement: .Mock.noDisplaysSample)

    XCTAssertEqual(viewModel.title, "n/a")
    XCTAssertEqual(viewModel.content, "n/a")
  }

  func testOpenAppStore() {
    viewModel.openAppStore()

    XCTAssertTrue(mockRouter.didCallExternalLink)
  }

  // MARK: Private

  // swiftlint:disable all
  private var mockRouter: VersionEnforcementRouterMock!
  private var mockVersionEnforcement: VersionEnforcement = .Mock.sample
  private var viewModel: VersionEnforcementViewModel!
  // swiftlint:enable all
}
