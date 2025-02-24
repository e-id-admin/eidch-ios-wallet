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
    contextSpy = LAContextProtocolSpy()

    useCase = ChangeBiometricStatusUseCase(
      requestBiometricAuthUseCase: requestBiometricAuthUseCaseSpy,
      uniquePassphraseManager: uniquePassphraseManagerSpy,
      allowBiometricUsageUseCase: allowBiometricUsageUseCaseSpy,
      hasBiometricAuthUseCase: hasBiometricAuthUseCaseSpy,
      isBiometricUsageAllowedUseCase: isBiometricUsageAllowedUseCaseSpy,
      context: contextSpy)
  }

  func testHappyPath_disable() async throws {
    let mockData = Data()

    isBiometricUsageAllowedUseCaseSpy.executeReturnValue = true
    hasBiometricAuthUseCaseSpy.executeReturnValue = true

    try await useCase.execute(with: mockData)

    XCTAssertTrue(uniquePassphraseManagerSpy.deleteBiometricUniquePassphraseCalled)
    XCTAssertTrue(allowBiometricUsageUseCaseSpy.executeAllowCalled)
    XCTAssertEqual(allowBiometricUsageUseCaseSpy.executeAllowReceivedInvocations.first, false)
  }

  func testHappyPath_enable() async throws {
    let mockData = Data()

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
  private var contextSpy: LAContextProtocolSpy!
  private var useCase: ChangeBiometricStatusUseCase!
  // swiftlint:enable all

}
