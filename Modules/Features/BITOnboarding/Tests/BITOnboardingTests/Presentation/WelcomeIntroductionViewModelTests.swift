import Foundation
import XCTest
@testable import BITOnboarding

class WelcomeIntroductionViewModelTests: XCTestCase {

  func testPrimaryAction() {
    let router = MockOnboardingInternalRoutes()
    let viewModel = WelcomeIntroductionViewModel(router: router)
    viewModel.primaryAction()

    XCTAssertTrue(router.infoScreenSecurityCalled)
  }

}
