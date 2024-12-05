import BITCore
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITCore
@testable import BITVault

// MARK: - LockWalletUseCaseTests

final class LockWalletUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    processInfoService = ProcessInfoServiceProtocolSpy()
    keyManagerProtocolSpy = KeyManagerProtocolSpy()
    spySecretManager = SecretManagerProtocolSpy()
    let repository = SecretsRepository(keyManager: keyManagerProtocolSpy, secretManager: spySecretManager, processInfoService: processInfoService)
    useCase = LockWalletUseCase(repository: repository)
  }

  func testLockWallet() throws {
    processInfoService.systemUptime = timeInterval
    try useCase.execute()

    spySecretManager.setForKeyQueryClosure = { value, _, _ in
      guard let value = value as? TimeInterval else { return XCTFail("Expected a TimeInterval...") }
      XCTAssertEqual(value, self.timeInterval)
    }

    XCTAssertTrue(spySecretManager.setForKeyQueryCalled)
    XCTAssertEqual(spySecretManager.setForKeyQueryCallsCount, 1)
  }

  // MARK: Private

  private let timeInterval: TimeInterval = 1000

  // swiftlint:disable all
  private var useCase: LockWalletUseCase!
  private var spySecretManager: SecretManagerProtocolSpy!
  private var processInfoService: ProcessInfoServiceProtocolSpy!
  private var keyManagerProtocolSpy: KeyManagerProtocolSpy!
  // swiftlint:enable all

}
