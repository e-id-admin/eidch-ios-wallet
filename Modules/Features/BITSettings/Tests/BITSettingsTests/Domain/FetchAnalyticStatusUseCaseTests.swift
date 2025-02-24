import Spyable
import XCTest
@testable import BITSettings

final class FetchAnalyticStatusUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    analyticsRepository = AnalyticsRepositoryProtocolSpy()

    useCase = FetchAnalyticStatusUseCase(analyticsRepository: analyticsRepository)
  }

  func testExecute_success() {
    analyticsRepository.isAnalyticsAllowedReturnValue = true

    let status = useCase.execute()

    XCTAssertTrue(analyticsRepository.isAnalyticsAllowedCalled)
    XCTAssertTrue(status)
  }

  // MARK: Private

  // swiftlint:disable implicitly_unwrapped_optional
  private var useCase: FetchAnalyticStatusUseCase!
  private var analyticsRepository: AnalyticsRepositoryProtocolSpy!
  // swiftlint:enable implicitly_unwrapped_optional
}
