import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITCore
@testable import BITVault

final class LockWalletRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    keyManagerProtocolSpy = KeyManagerProtocolSpy()
    processInfoService = ProcessInfoServiceProtocolSpy()
    secretManagerProtocolSpy = SecretManagerProtocolSpy()
    repository = SecretsRepository(keyManager: keyManagerProtocolSpy, secretManager: secretManagerProtocolSpy, processInfoService: processInfoService)
  }

  func testLockWallet() throws {
    let timeInterval: TimeInterval = 100
    processInfoService.systemUptime = timeInterval

    secretManagerProtocolSpy.setForKeyQueryClosure = { value, _, _ in
      guard let value = value as? Double else { return XCTFail("Expected a Double") }
      XCTAssertEqual(value, timeInterval)
    }

    try repository.lockWallet()
    XCTAssertTrue(secretManagerProtocolSpy.setForKeyQueryCalled)
    XCTAssertEqual(secretManagerProtocolSpy.setForKeyQueryCallsCount, 1)
  }

  func testUnlockWallet() throws {
    let timeInterval: TimeInterval = 100
    processInfoService.systemUptime = timeInterval

    secretManagerProtocolSpy.setForKeyQueryClosure = { value, _, _ in
      XCTAssertNil(value)
    }

    try repository.unlockWallet()
    XCTAssertTrue(secretManagerProtocolSpy.removeObjectForKeyQueryCalled)
    XCTAssertEqual(secretManagerProtocolSpy.removeObjectForKeyQueryCallsCount, 1)
  }

  func testTimeIntervalLockWallet() {
    let timeInterval: TimeInterval = 100
    secretManagerProtocolSpy.doubleForKeyQueryReturnValue = timeInterval

    let value = repository.getLockedWalletTimeInterval()
    XCTAssertEqual(value, timeInterval)

    XCTAssertTrue(secretManagerProtocolSpy.doubleForKeyQueryCalled)
    XCTAssertEqual(secretManagerProtocolSpy.doubleForKeyQueryCallsCount, 1)
    XCTAssertFalse(secretManagerProtocolSpy.removeObjectForKeyQueryCalled)
    XCTAssertFalse(secretManagerProtocolSpy.setForKeyQueryCalled)
  }

  func testNoTimeIntervalLockWallet() {
    secretManagerProtocolSpy.doubleForKeyQueryReturnValue = nil

    let value = repository.getLockedWalletTimeInterval()
    XCTAssertNil(value)

    XCTAssertTrue(secretManagerProtocolSpy.doubleForKeyQueryCalled)
    XCTAssertEqual(secretManagerProtocolSpy.doubleForKeyQueryCallsCount, 1)
    XCTAssertFalse(secretManagerProtocolSpy.removeObjectForKeyQueryCalled)
    XCTAssertFalse(secretManagerProtocolSpy.setForKeyQueryCalled)
  }

  // MARK: Private

  //swiftlint:disable all
  private var keyManagerProtocolSpy: KeyManagerProtocolSpy!
  private var processInfoService: ProcessInfoServiceProtocolSpy!
  private var secretManagerProtocolSpy: SecretManagerProtocolSpy!
  private var repository: LockWalletRepositoryProtocol!
  //swiftlint:enable all

}
