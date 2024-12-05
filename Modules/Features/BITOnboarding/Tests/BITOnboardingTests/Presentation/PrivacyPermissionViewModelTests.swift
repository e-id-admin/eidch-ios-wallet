import Foundation
import Spyable
import XCTest

@testable import BITOnboarding
@testable import BITSettings

final class PrivacyPermissionViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    super.setUp()

    updateAnalyticsStatusUseCase = UpdateAnalyticStatusUseCaseProtocolSpy()
    viewModel = PrivacyPermissionViewModel(
      router: OnboardingRouter(),
      updateAnalyticsStatusUseCase: updateAnalyticsStatusUseCase)
  }

  func testAcceptPrivacyPolicy() async {
    await viewModel.updatePrivacyPolicy(to: true)

    XCTAssertTrue(updateAnalyticsStatusUseCase.executeIsAllowedCalled)
    XCTAssertEqual(updateAnalyticsStatusUseCase.executeIsAllowedReceivedInvocations.first, true)
  }

  func testDeclinePrivacyPolicy() async {
    await viewModel.updatePrivacyPolicy(to: false)

    XCTAssertTrue(updateAnalyticsStatusUseCase.executeIsAllowedCalled)
    XCTAssertEqual(updateAnalyticsStatusUseCase.executeIsAllowedReceivedInvocations.first, false)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: PrivacyPermissionViewModel!
  private var updateAnalyticsStatusUseCase: UpdateAnalyticStatusUseCaseProtocolSpy!
  // swiftlint:enable all

}
