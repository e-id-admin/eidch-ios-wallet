import Spyable
import XCTest

@testable import BITAnalytics
@testable import BITSettings

final class UpdateAnalyticStatusUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    analyticsRepository = AnalyticsRepositoryProtocolSpy()

    useCase = UpdateAnalyticStatusUseCase(analyticsRepository: analyticsRepository)
  }

  func testExecute_success() async {
    let mockAllowAnalytics = true
    await useCase.execute(isAllowed: mockAllowAnalytics)

    XCTAssertTrue(analyticsRepository.allowAnalyticsCalled)
    XCTAssertEqual(analyticsRepository.allowAnalyticsReceivedInvocations.first, mockAllowAnalytics)
  }

  // MARK: Private

  // swiftlint:disable implicitly_unwrapped_optional
  private var useCase: UpdateAnalyticStatusUseCaseProtocol!
  private var analyticsRepository: AnalyticsRepositoryProtocolSpy!
  // swiftlint:enable implicitly_unwrapped_optional

}
