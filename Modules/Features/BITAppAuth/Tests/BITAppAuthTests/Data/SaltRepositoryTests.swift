import BITCore
import BITCrypto
import Foundation
import Spyable
import XCTest
@testable import BITAppAuth
@testable import BITTestingCore
@testable import BITVault

// MARK: - PepperRepositoryTests

final class SaltRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    keyManagerSpy = KeyManagerProtocolSpy()
    secretManagerSpy = SecretManagerProtocolSpy()
    repository = SecretsRepository(keyManager: keyManagerSpy, secretManager: secretManagerSpy)
  }

  func testSetPinSalt() throws {
    guard let mockData = "1234".data(using: .utf8) else {
      XCTFail("Can't create Data")
      return
    }
    secretManagerSpy.setForKeyQueryClosure = { _, _, _ in }

    try repository.setPinSalt(mockData)
    XCTAssertTrue(secretManagerSpy.setForKeyQueryCalled)
    XCTAssertEqual(mockData, secretManagerSpy.setForKeyQueryReceivedArguments?.value as? Data)
  }

  func getPinSalt() throws {
    guard let mockData = "1234".data(using: .utf8) else {
      XCTFail("Can't create Data")
      return
    }
    secretManagerSpy.dataForKeyQueryReturnValue = mockData

    let salt = try repository.getPinSalt()
    XCTAssertEqual(mockData, salt)
  }

  func getPinSalt_failure() throws {
    secretManagerSpy.dataForKeyQueryReturnValue = nil
    do {
      _ = try repository.getPinSalt()
      XCTFail("Expected error")
    } catch SecretsError.unavailableData {
      XCTAssertTrue(secretManagerSpy.setForKeyQueryCalled)
    } catch {
      XCTFail("Not the expected error: \(error)")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var secretManagerSpy: SecretManagerProtocolSpy!
  private var keyManagerSpy: KeyManagerProtocolSpy!
  private var repository: SaltRepositoryProtocol!
  // swiftlint:enable all
}
