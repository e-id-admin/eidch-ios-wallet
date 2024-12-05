import BITCore
import BITCrypto
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITLocalAuthentication
@testable import BITVault

final class UniquePassphraseRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    spyContext = LAContextProtocolSpy()
    keyManagerProtocolSpy = KeyManagerProtocolSpy()
    spySecretManager = SecretManagerProtocolSpy()

    repository = SecretsRepository(keyManager: keyManagerProtocolSpy, secretManager: spySecretManager)
  }

  func testSaveUniquePassphrase_appPin() throws {
    let mockData: Data = .init()
    let appPinAuthMethod: AuthMethod = .appPin
    let mockAccessControl = try createAccessControl(accessControlFlags: AuthMethod.appPin.accessControlFlags)
    try repository.saveUniquePassphrase(mockData, forAuthMethod: appPinAuthMethod, inContext: spyContext)
    XCTAssertTrue(spySecretManager.setForKeyQueryCalled)
    XCTAssertEqual(mockData, spySecretManager.setForKeyQueryReceivedArguments?.value as? Data)
    XCTAssertEqual(AuthMethod.appPin.identifierKey, spySecretManager.setForKeyQueryReceivedArguments?.key)
    //swiftlint:disable force_cast
    XCTAssertEqual(mockAccessControl, spySecretManager.setForKeyQueryReceivedArguments?.query?[kSecAttrAccessControl as String] as! SecAccessControl)
    //swiftlint:enable force_cast
  }

  func testSaveUniquePassphrase_biometric() throws {
    let mockData: Data = .init()
    let appPinAuthMethod: AuthMethod = .biometric
    let mockAccessControl = try createAccessControl(accessControlFlags: AuthMethod.biometric.accessControlFlags)
    try repository.saveUniquePassphrase(mockData, forAuthMethod: appPinAuthMethod, inContext: spyContext)
    XCTAssertTrue(spySecretManager.setForKeyQueryCalled)
    XCTAssertEqual(mockData, spySecretManager.setForKeyQueryReceivedArguments?.value as? Data)
    XCTAssertEqual(AuthMethod.biometric.identifierKey, spySecretManager.setForKeyQueryReceivedArguments?.key)
    //swiftlint:disable force_cast
    XCTAssertEqual(mockAccessControl, spySecretManager.setForKeyQueryReceivedArguments?.query?[kSecAttrAccessControl as String] as! SecAccessControl)
    //swiftlint:enable force_cast
  }

  func testGetUniquePassphrase_appPin() throws {
    let mockData: Data = .init()
    let appPinAuthMethod: AuthMethod = .appPin
    spySecretManager.dataForKeyQueryReturnValue = mockData
    let data = try repository.getUniquePassphrase(forAuthMethod: appPinAuthMethod, inContext: spyContext)
    XCTAssertEqual(mockData, data)
    XCTAssertTrue(spySecretManager.dataForKeyQueryCalled)
    XCTAssertEqual(AuthMethod.appPin.identifierKey, spySecretManager.dataForKeyQueryReceivedArguments?.key)
  }

  func testGetUniquePassphrase_biometric() throws {
    let mockData: Data = .init()
    let appPinAuthMethod: AuthMethod = .biometric
    spySecretManager.dataForKeyQueryReturnValue = mockData
    let data = try repository.getUniquePassphrase(forAuthMethod: appPinAuthMethod, inContext: spyContext)
    XCTAssertEqual(mockData, data)
    XCTAssertTrue(spySecretManager.dataForKeyQueryCalled)
    XCTAssertEqual(AuthMethod.biometric.identifierKey, spySecretManager.dataForKeyQueryReceivedArguments?.key)
  }

  func testDeleteBiometricUniquePassphrase() throws {
    try repository.deleteBiometricUniquePassphrase()

    XCTAssertTrue(spySecretManager.removeObjectForKeyQueryCalled)
    XCTAssertEqual(AuthMethod.biometric.identifierKey, spySecretManager.removeObjectForKeyQueryReceivedArguments?.key)
  }

  func testHasUniquePassphrase_appPin() throws {
    spySecretManager.existsKeyQueryReturnValue = true
    let hasSecret = repository.hasUniquePassphraseSaved(forAuthMethod: .appPin)
    XCTAssertTrue(hasSecret)
    XCTAssertTrue(spySecretManager.existsKeyQueryCalled)
    XCTAssertEqual(AuthMethod.appPin.identifierKey, spySecretManager.existsKeyQueryReceivedArguments?.key)
  }

  func testHasUniquePassphrase_biometric() throws {
    spySecretManager.existsKeyQueryReturnValue = true
    let hasSecret = repository.hasUniquePassphraseSaved(forAuthMethod: .biometric)
    XCTAssertTrue(hasSecret)
    XCTAssertTrue(spySecretManager.existsKeyQueryCalled)
    XCTAssertEqual(AuthMethod.biometric.identifierKey, spySecretManager.existsKeyQueryReceivedArguments?.key)
  }

  func testHasNotUniquePassphrase_appPin() throws {
    spySecretManager.existsKeyQueryReturnValue = false
    let hasSecret = repository.hasUniquePassphraseSaved(forAuthMethod: .appPin)
    XCTAssertFalse(hasSecret)
    XCTAssertTrue(spySecretManager.existsKeyQueryCalled)
    XCTAssertEqual(AuthMethod.appPin.identifierKey, spySecretManager.existsKeyQueryReceivedArguments?.key)
  }

  func testHasNotUniquePassphrase_biometric() throws {
    spySecretManager.existsKeyQueryReturnValue = false
    let hasSecret = repository.hasUniquePassphraseSaved(forAuthMethod: .biometric)
    XCTAssertFalse(hasSecret)
    XCTAssertTrue(spySecretManager.existsKeyQueryCalled)
    XCTAssertEqual(AuthMethod.biometric.identifierKey, spySecretManager.existsKeyQueryReceivedArguments?.key)
  }

  // MARK: Private

  private let vaultAlgorithm: VaultAlgorithm = .eciesEncryptionStandardVariableIVX963SHA256AESGCM

  //swiftlint:disable all
  private var spyContext: LAContextProtocolSpy!
  private var keyManagerProtocolSpy: KeyManagerProtocolSpy!
  private var spySecretManager: SecretManagerProtocolSpy!
  private var repository: UniquePassphraseRepositoryProtocol!

  //swiftlint:enable all

  private func createAccessControl(
    accessControlFlags: SecAccessControlCreateFlags = [.privateKeyUsage, .applicationPassword],
    protection: CFString = kSecAttrAccessibleWhenUnlockedThisDeviceOnly) throws
    -> SecAccessControl
  {
    var accessControlError: Unmanaged<CFError>?

    guard let accessControl = SecAccessControlCreateWithFlags( kCFAllocatorDefault, protection, accessControlFlags, &accessControlError) else {
      if let error = accessControlError?.takeRetainedValue() {
        throw VaultError.keyGenerationError(reason: "Access control creation failed with error: \(error)")
      } else {
        throw VaultError.keyGenerationError(reason: "Unknown error during access control creation.")
      }
    }
    return accessControl
  }

}
