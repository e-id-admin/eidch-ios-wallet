import Factory
import Foundation
import Spyable
import XCTest
@testable import BITAppAuth
@testable import BITLocalAuthentication
@testable import BITOpenID
@testable import BITTestingCore
@testable import BITVault

final class CredentialKeyPairGeneratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    keyManagerProtocolSpy = KeyManagerProtocolSpy()

    userSession.isLoggedIn = true
    userSession.context = LAContextProtocolSpy()

    Container.shared.keyManager.register { self.keyManagerProtocolSpy }
    Container.shared.vaultOptions.register { self.vaultOptions }
    Container.shared.vaultAccessControlFlags.register { self.mockControlAccessFlags }
    Container.shared.vaultProtection.register { self.mockProtection }
    Container.shared.userSession.register { self.userSession }

    generator = CredentialKeyPairGenerator()
  }

  func testCreatePrivateKey() throws {
    let mockSecKey = SecKeyTestsHelper.createPrivateKey()
    let mockAlgorithm = "ES256"
    let identifier = UUID()
    let mockReason = "mockReason"
    keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReturnValue = mockSecKey
    userSession.context?.localizedReason = mockReason

    let keyPair = try generator.generate(identifier: identifier, algorithm: mockAlgorithm)
    XCTAssertEqual(mockSecKey, keyPair.privateKey)
    XCTAssertTrue(keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryCalled)
    XCTAssertEqual(identifier.uuidString, keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.identifier)
    XCTAssertEqual(keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.algorithm, try VaultAlgorithm(fromSignatureAlgorithm: mockAlgorithm))
    XCTAssertEqual(keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.options, vaultOptions)
    XCTAssertEqual((keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.query?[kSecUseAuthenticationContext as String] as? LAContextProtocolSpy)?.localizedReason, mockReason) // Compare reason cause cannot compare LAContextProtocol
    // swiftlint:disable force_cast
    XCTAssertEqual(keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.query?[kSecAttrAccessControl as String] as! SecAccessControl, SecKeyTestsHelper.createAccessControl(accessControlFlags: mockControlAccessFlags, protection: mockProtection))
    // swiftlint:enable force_cast
  }

  func testCreatePrivateKey_UnknownAlgorithm_ThrowsError() throws {
    let mockAlgorithm = "unknown"
    let identifier = UUID()

    XCTAssertThrowsError(try generator.generate(identifier: identifier, algorithm: mockAlgorithm)) { error in
      XCTAssertEqual(error as? CredentialKeyPairGenerator.CredentialKeyPairGeneratorError, .invalidAlgorithm)
      XCTAssertFalse(keyManagerProtocolSpy.getPrivateKeyWithIdentifierAlgorithmQueryCalled)
    }
  }

  // MARK: Private

  private var keyManagerProtocolSpy = KeyManagerProtocolSpy()
  private var generator = CredentialKeyPairGenerator()
  private var userSession = SessionSpy()
  private var vaultOptions: VaultOption = []
  private var mockProtection = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
  private var mockControlAccessFlags: SecAccessControlCreateFlags = [.privateKeyUsage, .applicationPassword]
}
