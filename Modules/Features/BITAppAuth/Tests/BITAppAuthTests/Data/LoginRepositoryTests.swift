import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITCore
@testable import BITVault

final class LoginRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    secretManagerSpy = SecretManagerProtocolSpy()
    repository = LoginRepository(secretManager: secretManagerSpy)
  }

  func testRegisterAttempt() throws {
    let attempt = 2
    secretManagerSpy.setForKeyQueryClosure = { _, _, _ in }

    try repository.registerAttempt(attempt, kind: .appPin)
    XCTAssertTrue(secretManagerSpy.setForKeyQueryCalled)
    XCTAssertEqual(attempt, secretManagerSpy.setForKeyQueryReceivedArguments?.value as? Int)
    XCTAssertEqual(secretManagerSpy.setForKeyQueryCallsCount, 1)
  }

  func testReset() throws {
    var biometricAttempts = 2
    let pinAttempts = 3

    secretManagerSpy.setForKeyQueryClosure = { _, key, _ in
      if key == AuthMethod.biometric.attemptKey {
        biometricAttempts = 0
      }
    }

    try repository.registerAttempt(biometricAttempts, kind: .biometric)
    try repository.resetAttempts(kind: .biometric)

    XCTAssertEqual(biometricAttempts, 0)
    XCTAssertEqual(pinAttempts, 3)

    XCTAssertTrue(secretManagerSpy.setForKeyQueryCalled)
    XCTAssertEqual(secretManagerSpy.setForKeyQueryCallsCount, 1)
  }

  func testGetAttempt() throws {
    let attempt = 42
    secretManagerSpy.integerForKeyQueryReturnValue = attempt

    try XCTAssertEqual(repository.getAttempts(kind: .biometric), attempt)
    try XCTAssertEqual(repository.getAttempts(kind: .appPin), attempt)
    XCTAssertEqual(secretManagerSpy.integerForKeyQueryCallsCount, 2)
  }

  // MARK: Private

  // swiftlint:disable all
  private var secretManagerSpy: SecretManagerProtocolSpy!
  private var repository: LoginRepositoryProtocol!
  // swiftlint:enable all

}
