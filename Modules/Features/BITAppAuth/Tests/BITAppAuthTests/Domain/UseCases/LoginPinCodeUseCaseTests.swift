import BITCore
import Foundation
import Spyable
import XCTest
@testable import BITAppAuth
@testable import BITDataStore
@testable import BITLocalAuthentication

final class LoginPinCodeUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    spyGetUniquePassphraseUseCase = GetUniquePassphraseUseCaseProtocolSpy()
    spyIsBiometricInvalidatedUseCase = IsBiometricInvalidatedUseCaseProtocolSpy()
    spyUniquePassphraseManager = UniquePassphraseManagerProtocolSpy()
    contextManager = ContextManagerProtocolSpy()
    spyContext = LAContextProtocolSpy()
    dataStoreConfiguration = DataStoreConfigurationManagerProtocolSpy()

    useCase = LoginPinCodeUseCase(
      getUniquePassphraseUseCase: spyGetUniquePassphraseUseCase,
      isBiometricInvalidatedUseCase: spyIsBiometricInvalidatedUseCase,
      uniquePassphraseManager: spyUniquePassphraseManager,
      contextManager: contextManager,
      context: spyContext,
      dataStoreConfigurationManager: dataStoreConfiguration)
  }

  func testHappyPath_biometricsValid() throws {
    let mockPinCode = "123456"
    spyGetUniquePassphraseUseCase.executeFromReturnValue = Data()
    spyIsBiometricInvalidatedUseCase.executeReturnValue = false

    let didLoginNotification = expectation(forNotification: .didLogin, object: nil)

    try useCase.execute(from: mockPinCode)
    XCTAssertTrue(spyGetUniquePassphraseUseCase.executeFromCalled)
    XCTAssertEqual(mockPinCode, spyGetUniquePassphraseUseCase.executeFromReceivedPinCode)
    XCTAssertTrue(spyIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertFalse(spyUniquePassphraseManager.saveUniquePassphraseForContextCalled)

    XCTAssertTrue(dataStoreConfiguration.setEncryptionKeyCalled)
    XCTAssertEqual(dataStoreConfiguration.setEncryptionKeyCallsCount, 1)
    XCTAssertTrue(contextManager.setCredentialContextCalled)
    XCTAssertEqual(contextManager.setCredentialContextCallsCount, 1)

    wait(for: [didLoginNotification])
  }

  func testHappyPath_biometricsInValid() throws {
    let mockPinCode = "123456"
    let mockUniquePassphrase = Data()
    spyGetUniquePassphraseUseCase.executeFromReturnValue = mockUniquePassphrase
    spyIsBiometricInvalidatedUseCase.executeReturnValue = true

    try useCase.execute(from: mockPinCode)
    XCTAssertTrue(spyGetUniquePassphraseUseCase.executeFromCalled)
    XCTAssertEqual(mockPinCode, spyGetUniquePassphraseUseCase.executeFromReceivedPinCode)
    XCTAssertTrue(spyIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertTrue(spyUniquePassphraseManager.saveUniquePassphraseForContextCalled)
    XCTAssertEqual(mockUniquePassphrase, spyUniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.uniquePassphrase)
    XCTAssertEqual(AuthMethod.biometric, spyUniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.authMethod)
    XCTAssertTrue(dataStoreConfiguration.setEncryptionKeyCalled)
    XCTAssertTrue(contextManager.setCredentialContextCalled)
    XCTAssertEqual(contextManager.setCredentialContextCallsCount, 1)
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: LoginPinCodeUseCase!
  private var spyGetUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocolSpy!
  private var spyIsBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocolSpy!
  private var spyUniquePassphraseManager: UniquePassphraseManagerProtocolSpy!
  private var spyContext: LAContextProtocolSpy!
  private var contextManager: ContextManagerProtocolSpy!
  private var dataStoreConfiguration: DataStoreConfigurationManagerProtocolSpy!
  // swiftlint:enable all

}
