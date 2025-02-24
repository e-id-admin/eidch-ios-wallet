import Foundation
import XCTest
@testable import BITOnboarding

class CredentialIntroductionViewModelTests: XCTestCase {

  func testPrimaryAction() {
    let router = MockOnboardingInternalRoutes()
    let viewModel = CredentialIntroductionViewModel(router: router)
    viewModel.primaryAction()

    XCTAssertTrue(router.privacyPermissionCalled)
  }

}
