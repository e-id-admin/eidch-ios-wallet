import Factory
import Foundation
import XCTest
@testable import BITAppAuth

final class IsUserLoggedInUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    userSession = SessionSpy()
    Container.shared.userSession.register { self.userSession }

    useCase = IsUserLoggedInUseCase()
  }

  func testIsLoggedIn() {
    userSession.isLoggedIn = true

    XCTAssertTrue(useCase.execute())
  }

  func testIsLoggedOut() {
    userSession.isLoggedIn = false

    XCTAssertFalse(useCase.execute())
  }

  // MARK: Private

  private var userSession = SessionSpy()
  private var useCase = IsUserLoggedInUseCase()

}
