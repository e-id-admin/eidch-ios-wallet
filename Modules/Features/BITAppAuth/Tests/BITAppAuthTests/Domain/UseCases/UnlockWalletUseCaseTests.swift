import BITCore
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITCore
@testable import BITVault

// MARK: - UnlockWalletUseCaseTests

final class UnlockWalletUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    processInfoService = ProcessInfoServiceProtocolSpy()
    keyManagerProtocolSpy = KeyManagerProtocolSpy()
    secretManagerProtocolSpy = SecretManagerProtocolSpy()
    let repository = SecretsRepository(keyManager: keyManagerProtocolSpy, secretManager: secretManagerProtocolSpy, processInfoService: processInfoService)
    useCase = UnlockWalletUseCase(repository: repository)
  }

  func testUnlockWallet() throws {
    try useCase.execute()

    secretManagerProtocolSpy.setForKeyQueryClosure = { value, _, _ in
      XCTAssertNil(value)
    }

    XCTAssertTrue(secretManagerProtocolSpy.removeObjectForKeyQueryCalled)
    XCTAssertEqual(secretManagerProtocolSpy.removeObjectForKeyQueryCallsCount, 1)
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: UnlockWalletUseCase!
  private var keyManagerProtocolSpy: KeyManagerProtocolSpy!
  private var processInfoService: ProcessInfoServiceProtocolSpy!
  private var secretManagerProtocolSpy: SecretManagerProtocolSpy!
  // swiftlint:enable all

}
