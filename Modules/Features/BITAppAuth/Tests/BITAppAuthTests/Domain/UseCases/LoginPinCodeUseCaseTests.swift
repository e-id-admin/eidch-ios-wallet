import BITCore
import Factory
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

    getUniquePassphraseUseCase = GetUniquePassphraseUseCaseProtocolSpy()
    isBiometricInvalidatedUseCase = IsBiometricInvalidatedUseCaseProtocolSpy()
    uniquePassphraseManager = UniquePassphraseManagerProtocolSpy()
    userSession = SessionSpy()
    dataStoreConfiguration = DataStoreConfigurationManagerProtocolSpy()

    Container.shared.getUniquePassphraseUseCase.register { self.getUniquePassphraseUseCase }
    Container.shared.isBiometricInvalidatedUseCase.register { self.isBiometricInvalidatedUseCase }
    Container.shared.uniquePassphraseManager.register { self.uniquePassphraseManager }
    Container.shared.userSession.register { self.userSession }
    Container.shared.dataStoreConfigurationManager.register { self.dataStoreConfiguration }

    useCase = LoginPinCodeUseCase()
  }

  func testHappyPath_biometricsValid() throws {
    let mockPinCode = "123456"
    userSession.startSessionPassphraseCredentialTypeReturnValue = LAContextProtocolSpy()
    getUniquePassphraseUseCase.executeFromReturnValue = Data()
    isBiometricInvalidatedUseCase.executeReturnValue = false

    let didLoginNotification = expectation(forNotification: .didLogin, object: nil)

    try useCase.execute(from: mockPinCode)
    XCTAssertTrue(getUniquePassphraseUseCase.executeFromCalled)
    XCTAssertEqual(mockPinCode, getUniquePassphraseUseCase.executeFromReceivedPinCode)
    XCTAssertTrue(isBiometricInvalidatedUseCase.executeCalled)
    XCTAssertFalse(uniquePassphraseManager.saveUniquePassphraseForContextCalled)

    XCTAssertTrue(dataStoreConfiguration.setEncryptionKeyCalled)
    XCTAssertEqual(dataStoreConfiguration.setEncryptionKeyCallsCount, 1)
    XCTAssertTrue(userSession.startSessionPassphraseCredentialTypeCalled)
    XCTAssertEqual(userSession.startSessionPassphraseCredentialTypeCallsCount, 1)

    wait(for: [didLoginNotification])
  }

  func testHappyPath_biometricsInValid() throws {
    let mockPinCode = "123456"
    let mockUniquePassphrase = Data()
    userSession.startSessionPassphraseCredentialTypeReturnValue = LAContextProtocolSpy()

    getUniquePassphraseUseCase.executeFromReturnValue = mockUniquePassphrase
    isBiometricInvalidatedUseCase.executeReturnValue = true

    try useCase.execute(from: mockPinCode)
    XCTAssertTrue(getUniquePassphraseUseCase.executeFromCalled)
    XCTAssertEqual(mockPinCode, getUniquePassphraseUseCase.executeFromReceivedPinCode)
    XCTAssertTrue(isBiometricInvalidatedUseCase.executeCalled)
    XCTAssertTrue(uniquePassphraseManager.saveUniquePassphraseForContextCalled)
    XCTAssertEqual(mockUniquePassphrase, uniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.uniquePassphrase)
    XCTAssertEqual(AuthMethod.biometric, uniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.authMethod)
    XCTAssertTrue(dataStoreConfiguration.setEncryptionKeyCalled)
    XCTAssertTrue(userSession.startSessionPassphraseCredentialTypeCalled)
    XCTAssertEqual(userSession.startSessionPassphraseCredentialTypeCallsCount, 1)
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: LoginPinCodeUseCase!
  private var getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocolSpy!
  private var isBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocolSpy!
  private var uniquePassphraseManager: UniquePassphraseManagerProtocolSpy!
  private var userSession: SessionSpy!
  private var dataStoreConfiguration: DataStoreConfigurationManagerProtocolSpy!
  // swiftlint:enable all

}
