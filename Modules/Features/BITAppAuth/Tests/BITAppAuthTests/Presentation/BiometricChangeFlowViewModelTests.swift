import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITTestingCore

final class BiometricChangeFlowViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    getUniquePassphraseUseCase = GetUniquePassphraseUseCaseProtocolSpy()
    changeBiometricStatusUseCase = ChangeBiometricStatusUseCaseProtocolSpy()
    hasBiometricAuthUseCase = HasBiometricAuthUseCaseProtocolSpy()
    hasBiometricAuthUseCase.executeReturnValue = true
    viewModel = createViewModel()
  }

  @MainActor
  func testInitialState_hasBiometricAuth() {
    hasBiometricAuthUseCase.executeReturnValue = true
    viewModel = createViewModel()
    XCTAssertTrue(viewModel.isPresented)
    XCTAssertEqual(viewModel.currentIndex, 1)
    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.pinCodeState, .normal)
  }

  @MainActor
  func testInitialState_noBiometricAuth() {
    hasBiometricAuthUseCase.executeReturnValue = false
    viewModel = createViewModel()
    XCTAssertTrue(viewModel.isPresented)
    XCTAssertEqual(viewModel.currentIndex, 0)
    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.pinCodeState, .normal)
  }

  @MainActor
  func testPinCode_success() async throws {
    let pinCode = "123456"
    let mockData = Data()
    getUniquePassphraseUseCase.executeFromReturnValue = mockData

    viewModel.viewDidAppear()
    viewModel.pinCode = pinCode
    try? await Task.sleep(nanoseconds: 200_000_000)

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertFalse(viewModel.isPresented)

    XCTAssertEqual(viewModel.currentIndex, 1)
    XCTAssertTrue(getUniquePassphraseUseCase.executeFromCalled)
    XCTAssertEqual(getUniquePassphraseUseCase.executeFromReceivedInvocations.first, pinCode)
    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(changeBiometricStatusUseCase.executeWithCalled)
  }

  @MainActor
  func testPinCode_tooShort() async throws {
    let pinCode = "12456"
    let mockData = Data()
    getUniquePassphraseUseCase.executeFromReturnValue = mockData

    viewModel.viewDidAppear()
    viewModel.pinCode = pinCode
    try? await Task.sleep(nanoseconds: 200_000_000)

    XCTAssertFalse(viewModel.pinCode.isEmpty)
    XCTAssertTrue(viewModel.isPresented)

    XCTAssertEqual(viewModel.currentIndex, 1)
    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
    XCTAssertFalse(getUniquePassphraseUseCase.executeFromCalled)
    XCTAssertFalse(changeBiometricStatusUseCase.executeWithCalled)
  }

  @MainActor
  func testChangeBiometricStatus_failure() async throws {
    let pinCode = "123456"
    let mockData = Data()
    getUniquePassphraseUseCase.executeFromReturnValue = mockData
    changeBiometricStatusUseCase.executeWithThrowableError = TestingError.error

    viewModel.viewDidAppear()
    viewModel.pinCode = pinCode
    try? await Task.sleep(nanoseconds: 200_000_000)

    XCTAssertFalse(viewModel.pinCode.isEmpty)
    XCTAssertTrue(viewModel.isPresented)
    XCTAssertEqual(viewModel.currentIndex, 1)
    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(getUniquePassphraseUseCase.executeFromCalled)
    XCTAssertTrue(changeBiometricStatusUseCase.executeWithCalled)
  }

  @MainActor
  func testChangeBiometricStatus_userCancel() async {
    let pinCode = "123456"
    let mockData = Data()
    getUniquePassphraseUseCase.executeFromReturnValue = mockData
    changeBiometricStatusUseCase.executeWithThrowableError = ChangeBiometricStatusError.userCancel

    viewModel.viewDidAppear()
    viewModel.pinCode = pinCode
    try? await Task.sleep(nanoseconds: 200_000_000)

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertTrue(viewModel.isPresented)
    XCTAssertEqual(viewModel.currentIndex, 1)
    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(getUniquePassphraseUseCase.executeFromCalled)
    XCTAssertTrue(changeBiometricStatusUseCase.executeWithCalled)
  }

  @MainActor
  func testChangeBiometricStatus_noBiometrics() async throws {
    let pinCode = "123456"
    let mockData = Data()
    getUniquePassphraseUseCase.executeFromReturnValue = mockData
    hasBiometricAuthUseCase.executeReturnValue = false

    viewModel.viewDidAppear()
    viewModel.pinCode = pinCode
    try? await Task.sleep(nanoseconds: 200_000_000)

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertFalse(viewModel.isPresented)
    XCTAssertEqual(viewModel.currentIndex, 0)
    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(getUniquePassphraseUseCase.executeFromCalled)
    XCTAssertTrue(changeBiometricStatusUseCase.executeWithCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: BiometricChangeFlowViewModel!
  private var pinCodeSize: Int = 6
  private var isPresented: Bool = true
  private var getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocolSpy!
  private var changeBiometricStatusUseCase: ChangeBiometricStatusUseCaseProtocolSpy!
  private var hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocolSpy!

  // swiftlint:enable all

  @MainActor
  private func createViewModel() -> BiometricChangeFlowViewModel {
    BiometricChangeFlowViewModel(
      isPresented: .init(get: { self.isPresented }, set: { value in self.isPresented = value }),
      isBiometricEnabled: true,
      getUniquePassphraseUseCase: getUniquePassphraseUseCase,
      changeBiometricStatusUseCase: changeBiometricStatusUseCase,
      hasBiometricAuthUseCase: hasBiometricAuthUseCase,
      animationDuration: 0.0)
  }

}
