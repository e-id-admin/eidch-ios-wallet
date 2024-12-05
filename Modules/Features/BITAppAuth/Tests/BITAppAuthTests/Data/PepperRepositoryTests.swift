import BITCore
import BITCrypto
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITTestingCore
@testable import BITVault

// MARK: - PepperRepositoryTests

final class PepperRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    keyManagerProtocolSpy = KeyManagerProtocolSpy()
    secretManagerProtocolSpy = SecretManagerProtocolSpy()
    repository = SecretsRepository(keyManager: keyManagerProtocolSpy, secretManager: secretManagerProtocolSpy)
  }

  func testCreatePepperKey() throws {
    let mockSecKey: SecKey = SecKeyTestsHelper.createPrivateKey()
    keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReturnValue = mockSecKey
    let secKey = try repository.createPepperKey()
    XCTAssertEqual(mockSecKey, secKey)
    XCTAssertTrue(keyManagerProtocolSpy.deleteKeyPairWithIdentifierAlgorithmCalled)
    XCTAssertEqual(vaultAlgorithm, keyManagerProtocolSpy.deleteKeyPairWithIdentifierAlgorithmReceivedArguments?.algorithm)
    XCTAssertTrue(keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryCalled)
    XCTAssertEqual(vaultAlgorithm, keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.algorithm)
    XCTAssertEqual([.secureEnclavePermanently], keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.options)
    XCTAssertEqual(keyManagerProtocolSpy.deleteKeyPairWithIdentifierAlgorithmReceivedArguments?.identifier, keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.identifier)
  }

  func testGetPepperKey() throws {
    let mockSecKey: SecKey = SecKeyTestsHelper.createPrivateKey()
    keyManagerProtocolSpy.getPrivateKeyWithIdentifierAlgorithmQueryReturnValue = mockSecKey
    let secKey = try repository.getPepperKey()
    XCTAssertEqual(mockSecKey, secKey)
    XCTAssertTrue(keyManagerProtocolSpy.getPrivateKeyWithIdentifierAlgorithmQueryCalled)
    XCTAssertEqual(vaultAlgorithm, keyManagerProtocolSpy.getPrivateKeyWithIdentifierAlgorithmQueryReceivedArguments?.algorithm)
  }

  func testGetPeppeInitialVector() throws {
    let mockData: Data = .init()
    secretManagerProtocolSpy.dataForKeyQueryReturnValue = mockData
    let data = try repository.getPepperInitialVector()
    XCTAssertEqual(mockData, data)
    XCTAssertTrue(secretManagerProtocolSpy.dataForKeyQueryCalled)
  }

  func testSetPepperInitialVector() throws {
    let mockData: Data = .init()
    let mockAccessControl = try SecAccessControl.create(accessControlFlags: [], protection: kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
    try repository.setPepperInitialVector(mockData)
    XCTAssertTrue(secretManagerProtocolSpy.setForKeyQueryCalled)
    XCTAssertEqual(mockData, secretManagerProtocolSpy.setForKeyQueryReceivedArguments?.value as? Data)
    //swiftlint:disable force_cast
    XCTAssertEqual(mockAccessControl, secretManagerProtocolSpy.setForKeyQueryReceivedArguments?.query?[kSecAttrAccessControl as String] as! SecAccessControl)
    //swiftlint:enable force_cast
  }

  // MARK: Private

  private let vaultAlgorithm: VaultAlgorithm = .eciesEncryptionStandardVariableIVX963SHA256AESGCM

  //swiftlint:disable all
  private var secretManagerProtocolSpy: SecretManagerProtocolSpy!
  private var keyManagerProtocolSpy: KeyManagerProtocolSpy!
  private var repository: PepperRepositoryProtocol!
  //swiftlint:enable all

}
