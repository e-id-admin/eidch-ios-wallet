import BITCore
import Factory
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITLocalAuthentication

final class IsUserLoggedInUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    context = LAContextProtocolSpy()
    useCase = IsUserLoggedInUseCase()
  }

  func test_loggedIn() throws {
    context.isCredentialSetReturnValue = true
    Container.shared.authContext.register { self.context }

    XCTAssertTrue(useCase.execute())
    XCTAssertTrue(context.isCredentialSetCalled)
    XCTAssertEqual(context.isCredentialSetCallsCount, 1)
  }

  func test_loggedOut() throws {
    context.isCredentialSetReturnValue = false
    Container.shared.authContext.register { self.context }

    XCTAssertFalse(useCase.execute())
    XCTAssertTrue(context.isCredentialSetCalled)
    XCTAssertEqual(context.isCredentialSetCallsCount, 1)
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: IsUserLoggedInUseCase!
  private var context: LAContextProtocolSpy!
  // swiftlint:enable all

}
