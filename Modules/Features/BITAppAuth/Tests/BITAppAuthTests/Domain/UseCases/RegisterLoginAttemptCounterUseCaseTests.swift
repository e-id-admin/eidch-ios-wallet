import BITCore
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth

final class RegisterLoginAttemptCounterUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    repository = LoginRepositoryProtocolSpy()
    useCase = RegisterLoginAttemptCounterUseCase(repository: repository)
  }

  func testHappyPath_biometrics() throws {
    let attempt = 0
    let expectation = 1
    repository.getAttemptsKindReturnValue = attempt
    repository.registerAttemptKindReturnValue = expectation

    let result = try useCase.execute(kind: .biometric)

    XCTAssertEqual(repository.getAttemptsKindReceivedKind, .biometric)
    XCTAssertTrue(repository.registerAttemptKindCalled)
    XCTAssertEqual(repository.registerAttemptKindCallsCount, 1)
    XCTAssertEqual(expectation, result)
  }

  func testHappyPath_pin() throws {
    let attempt = 0
    let expectation = 1
    repository.getAttemptsKindReturnValue = attempt
    repository.registerAttemptKindReturnValue = expectation

    let result = try useCase.execute(kind: .appPin)

    XCTAssertEqual(repository.getAttemptsKindReceivedKind, .appPin)
    XCTAssertTrue(repository.registerAttemptKindCalled)
    XCTAssertEqual(repository.registerAttemptKindCallsCount, 1)
    XCTAssertEqual(expectation, result)
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: RegisterLoginAttemptCounterUseCase!
  private var repository: LoginRepositoryProtocolSpy!
  // swiftlint:enable all

}
