import Factory
import Foundation
import Spyable
import XCTest
@testable import BITAppAuth
@testable import BITDataStore
@testable import BITLocalAuthentication
@testable import BITTestingCore

// MARK: - RegisterPinCodeUseCaseTests

final class RegisterPinCodeUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    pinCodeManager = PinCodeManagerProtocolSpy()
    saltService = SaltServiceProtocolSpy()
    pepperService = PepperServiceProtocolSpy()
    uniquePassphraseManager = UniquePassphraseManagerProtocolSpy()
    internalContext = LAContextProtocolSpy()
    isBiometricUsageAllowedUseCase = IsBiometricUsageAllowedUseCaseProtocolSpy()
    dataStoreConfiguration = DataStoreConfigurationManagerProtocolSpy()
    userSession = SessionSpy()

    Container.shared.pinCodeManager.register { self.pinCodeManager }
    Container.shared.saltService.register { self.saltService }
    Container.shared.pepperService.register { self.pepperService }
    Container.shared.uniquePassphraseManager.register { self.uniquePassphraseManager }
    Container.shared.userSession.register { self.userSession }
    Container.shared.internalContext.register { self.internalContext }
    Container.shared.isBiometricUsageAllowedUseCase.register { self.isBiometricUsageAllowedUseCase }
    Container.shared.dataStoreConfigurationManager.register { self.dataStoreConfiguration }

    useCase = RegisterPinCodeUseCase()
  }

  func testStandardPinCode() throws {
    try testHappyPath(pinCode: "123456")
  }

  func testSpecialCharsPinCode() throws {
    try testHappyPath(pinCode: "aA#$_0")
  }

  func testLongPinCode() throws {
    try testHappyPath(pinCode: "12345678901234567890")
  }

  func testValidationError() throws {
    let pinCode: PinCode = "1"
    saltService.generateSaltReturnValue = pinCode.data(using: .utf8)
    pepperService.generatePepperReturnValue = SecKeyTestsHelper.createPrivateKey()
    pinCodeManager.encryptThrowableError = PinCodeError.tooShort
    internalContext.setCredentialTypeReturnValue = true
    do {
      try useCase.execute(pinCode: pinCode)
      XCTFail("Should fail instead...")
    } catch PinCodeError.tooShort {
      XCTAssertTrue(pinCodeManager.encryptCalled)
      XCTAssertTrue(saltService.generateSaltCalled)
      XCTAssertTrue(pepperService.generatePepperCalled)
      XCTAssertFalse(userSession.startSessionPassphraseCredentialTypeCalled)
      XCTAssertFalse(uniquePassphraseManager.generateCalled)
      XCTAssertFalse(uniquePassphraseManager.saveUniquePassphraseForContextCalled)
      XCTAssertFalse(isBiometricUsageAllowedUseCase.executeCalled)
      XCTAssertFalse(dataStoreConfiguration.setEncryptionKeyCalled)
    } catch {
      XCTFail("Unexpected error type")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var pinCodeManager: PinCodeManagerProtocolSpy!
  private var saltService: SaltServiceProtocolSpy!
  private var pepperService: PepperServiceProtocolSpy!
  private var uniquePassphraseManager: UniquePassphraseManagerProtocolSpy!
  private var useCase: RegisterPinCodeUseCase!
  private var isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocolSpy!
  private var dataStoreConfiguration: DataStoreConfigurationManagerProtocolSpy!
  private var userSession: SessionSpy!
  private var internalContext: LAContextProtocolSpy!
  // swiftlint:enable all

}

extension RegisterPinCodeUseCaseTests {

  private func testHappyPath(pinCode: PinCode) throws {
    let mockPinCodeEncrypted = Data()
    let mockUniquePassphraseData = Data()
    let mockSalt = Data()
    let mockPepperKey: SecKey = SecKeyTestsHelper.createPrivateKey()
    internalContext.setCredentialTypeReturnValue = true
    userSession.startSessionPassphraseCredentialTypeReturnValue = LAContextProtocolSpy()
    isBiometricUsageAllowedUseCase.executeReturnValue = true
    configureSpy(pinCodeEncrypted: mockPinCodeEncrypted, uniquePassphrase: mockUniquePassphraseData, salt: mockSalt, pepperKey: mockPepperKey)

    try useCase.execute(pinCode: pinCode)
    assertResult(pinCode: pinCode, pinCodeEncrypted: mockPinCodeEncrypted, uniquePassphrase: mockUniquePassphraseData)
  }

  private func configureSpy(pinCodeEncrypted: Data, uniquePassphrase: Data, salt: Data, pepperKey: SecKey) {
    pinCodeManager.encryptReturnValue = pinCodeEncrypted
    uniquePassphraseManager.generateReturnValue = uniquePassphrase
    saltService.generateSaltReturnValue = salt
    pepperService.generatePepperReturnValue = pepperKey
  }

  private func assertResult(pinCode: PinCode, pinCodeEncrypted: Data, uniquePassphrase: Data) {
    XCTAssertTrue(pinCodeManager.encryptCalled)
    XCTAssertTrue(saltService.generateSaltCalled)
    XCTAssertTrue(pepperService.generatePepperCalled)
    XCTAssertTrue(userSession.startSessionPassphraseCredentialTypeCalled)
    XCTAssertTrue(uniquePassphraseManager.generateCalled)
    XCTAssertTrue(uniquePassphraseManager.saveUniquePassphraseForContextCalled)
    XCTAssertEqual(pinCodeManager.encryptReceivedPinCode, pinCode)
    XCTAssertEqual(userSession.startSessionPassphraseCredentialTypeCallsCount, 1)
    XCTAssertEqual(pinCodeEncrypted, userSession.startSessionPassphraseCredentialTypeReceivedInvocations[0].passphrase)
    XCTAssertEqual(uniquePassphrase, uniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.uniquePassphrase)
    XCTAssertEqual(AuthMethod.biometric, uniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.authMethod)
    XCTAssertTrue(isBiometricUsageAllowedUseCase.executeCalled)

    XCTAssertTrue(dataStoreConfiguration.setEncryptionKeyCalled)
    XCTAssertEqual(dataStoreConfiguration.setEncryptionKeyCallsCount, 1)
  }

}
