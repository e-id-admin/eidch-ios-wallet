import Factory
import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITCore
@testable import BITTestingCore
@testable import BITVault

final class LockWalletRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    registerMocks()
    repository = SecretsRepository()
    success()
  }

  func testLockWallet_success() throws {
    try repository.lockWallet()

    XCTAssertEqual(secretManagerSpy.setForKeyQueryReceivedArguments?.key, secretsKey)
    XCTAssertEqual(secretManagerSpy.setForKeyQueryReceivedArguments?.value as? Double, timeInterval)
  }

  func testLockWallet_secretManagerThrowsError_throwsError() throws {
    secretManagerSpy.setForKeyQueryThrowableError = TestingError.error

    XCTAssertThrowsError(try repository.lockWallet()) { error in
      XCTAssertEqual(error as? TestingError, .error)
    }
  }

  func testUnlockWallet_success() throws {
    try repository.unlockWallet()

    XCTAssertEqual(secretManagerSpy.removeObjectForKeyQueryReceivedArguments?.key, secretsKey)
  }

  func testUnlockWallet_secretManagerThrowsError_throwsError() throws {
    secretManagerSpy.removeObjectForKeyQueryThrowableError = TestingError.error

    XCTAssertThrowsError(try repository.unlockWallet()) { error in
      XCTAssertEqual(error as? TestingError, .error)
    }
  }

  func testGetLockedWalletTimeInterval_exists_returnsInterval() throws {
    secretManagerSpy.doubleForKeyQueryReturnValue = timeInterval

    let result = try repository.getLockedWalletTimeInterval()

    XCTAssertEqual(result, timeInterval)
    XCTAssertFalse(secretManagerSpy.removeObjectForKeyQueryCalled)
    XCTAssertFalse(secretManagerSpy.setForKeyQueryCalled)
  }

  func testGetLockedWalletTimeInterval_doesNotExist_returnsNil() throws {
    secretManagerSpy.doubleForKeyQueryReturnValue = nil

    let result = try repository.getLockedWalletTimeInterval()

    XCTAssertNil(result)
    XCTAssertFalse(secretManagerSpy.removeObjectForKeyQueryCalled)
    XCTAssertFalse(secretManagerSpy.setForKeyQueryCalled)
  }

  // MARK: Private

  private let timeInterval: TimeInterval = 100
  private let secretsKey = "lockedWalletUptime"

  // swiftlint:disable all
  private var secretManagerSpy: SecretManagerProtocolSpy!
  private var keyManagerSpy: KeyManagerProtocolSpy!
  private var processInfoServiceSpy: ProcessInfoServiceProtocolSpy!
  private var repository: LockWalletRepositoryProtocol!

  // swiftlint:enable all

  private func registerMocks() {
    secretManagerSpy = SecretManagerProtocolSpy()
    keyManagerSpy = KeyManagerProtocolSpy()
    processInfoServiceSpy = ProcessInfoServiceProtocolSpy()

    Container.shared.secretManager.register { self.secretManagerSpy }
    Container.shared.keyManager.register { self.keyManagerSpy }
    Container.shared.processInfoService.register { self.processInfoServiceSpy }
  }

  private func success() {
    processInfoServiceSpy.systemUptime = timeInterval
  }

}
