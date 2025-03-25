import Factory
import LocalAuthentication
import XCTest
@testable import BITAppAuth
@testable import BITLocalAuthentication

final class ChangeBiometricStatusUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    requestBiometricAuthUseCaseSpy = RequestBiometricAuthUseCaseProtocolSpy()
    uniquePassphraseManagerSpy = UniquePassphraseManagerProtocolSpy()
    allowBiometricUsageUseCaseSpy = AllowBiometricUsageUseCaseProtocolSpy()
    hasBiometricAuthUseCaseSpy = HasBiometricAuthUseCaseProtocolSpy()
    isBiometricUsageAllowedUseCaseSpy = IsBiometricUsageAllowedUseCaseProtocolSpy()
    userSession = SessionSpy()

    Container.shared.requestBiometricAuthUseCase.register { self.requestBiometricAuthUseCaseSpy }
    Container.shared.uniquePassphraseManager.register { self.uniquePassphraseManagerSpy }
    Container.shared.allowBiometricUsageUseCase.register { self.allowBiometricUsageUseCaseSpy }
    Container.shared.hasBiometricAuthUseCase.register { self.hasBiometricAuthUseCaseSpy }
    Container.shared.isBiometricUsageAllowedUseCase.register { self.isBiometricUsageAllowedUseCaseSpy }
    Container.shared.userSession.register { self.userSession }

    useCase = ChangeBiometricStatusUseCase()
  }

  func testHappyPath_disable() async throws {
    let mockData = Data()

    userSession.isLoggedIn = true
    userSession.context = LAContextProtocolSpy()
    isBiometricUsageAllowedUseCaseSpy.executeReturnValue = true
    hasBiometricAuthUseCaseSpy.executeReturnValue = true

    try await useCase.execute(with: mockData)

    XCTAssertTrue(uniquePassphraseManagerSpy.deleteBiometricUniquePassphraseCalled)
    XCTAssertTrue(allowBiometricUsageUseCaseSpy.executeAllowCalled)
    XCTAssertEqual(allowBiometricUsageUseCaseSpy.executeAllowReceivedInvocations.first, false)
  }

  func testHappyPath_enable() async throws {
    let mockData = Data()

    userSession.isLoggedIn = true
    userSession.context = LAContextProtocolSpy()
    isBiometricUsageAllowedUseCaseSpy.executeReturnValue = false
    hasBiometricAuthUseCaseSpy.executeReturnValue = true

    try await useCase.execute(with: mockData)

    XCTAssertTrue(requestBiometricAuthUseCaseSpy.executeReasonContextCalled)
    XCTAssertTrue(uniquePassphraseManagerSpy.saveUniquePassphraseForContextCalled)
    XCTAssertEqual(uniquePassphraseManagerSpy.saveUniquePassphraseForContextReceivedArguments?.authMethod, .biometric)
    XCTAssertEqual(uniquePassphraseManagerSpy.saveUniquePassphraseForContextReceivedArguments?.uniquePassphrase, mockData)
    XCTAssertTrue(allowBiometricUsageUseCaseSpy.executeAllowCalled)
    XCTAssertEqual(allowBiometricUsageUseCaseSpy.executeAllowReceivedInvocations.first, true)
  }

  func testEnableWithBiometricCancelError() async throws {
    let mockData = Data()

    userSession.isLoggedIn = true
    userSession.context = LAContextProtocolSpy()

    isBiometricUsageAllowedUseCaseSpy.executeReturnValue = false
    hasBiometricAuthUseCaseSpy.executeReturnValue = true
    requestBiometricAuthUseCaseSpy.executeReasonContextThrowableError = LAError(LAError.Code.userCancel)

    do {
      try await useCase.execute(with: mockData)
      XCTFail("No error was thrown.")
    } catch ChangeBiometricStatusError.userCancel {
      XCTAssertTrue(requestBiometricAuthUseCaseSpy.executeReasonContextCalled)
      XCTAssertFalse(uniquePassphraseManagerSpy.saveUniquePassphraseForContextCalled)
      XCTAssertFalse(allowBiometricUsageUseCaseSpy.executeAllowCalled)
    } catch {
      XCTFail("Unexpected error type")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var requestBiometricAuthUseCaseSpy: RequestBiometricAuthUseCaseProtocolSpy!
  private var uniquePassphraseManagerSpy: UniquePassphraseManagerProtocolSpy!
  private var allowBiometricUsageUseCaseSpy: AllowBiometricUsageUseCaseProtocolSpy!
  private var hasBiometricAuthUseCaseSpy: HasBiometricAuthUseCaseProtocolSpy!
  private var isBiometricUsageAllowedUseCaseSpy: IsBiometricUsageAllowedUseCaseProtocolSpy!
  private var userSession: SessionSpy!
  private var useCase: ChangeBiometricStatusUseCase!
  // swiftlint:enable all

}
