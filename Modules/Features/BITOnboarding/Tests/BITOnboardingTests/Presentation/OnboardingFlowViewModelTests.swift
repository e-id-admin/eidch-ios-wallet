// import Factory
// import Spyable
// import XCTest
//
// @testable import BITAppAuth
// @testable import BITOnboarding
// @testable import BITSettings
//
// @MainActor
// final class OnboardingViewModelTests: XCTestCase {
//
//  // MARK: Public
//
//  public override func setUp() {
//    super.setUp()
//    registerPinCodeUseCase = RegisterPinCodeUseCaseProtocolSpy()
//    hasBiometricAuthUseCase = HasBiometricAuthUseCaseProtocolSpy()
//    hasBiometricAuthUseCase.executeReturnValue = true
//    getBiometricTypeUseCase = GetBiometricTypeUseCaseProtocolSpy()
//    getBiometricTypeUseCase.executeReturnValue = .faceID
//    requestBiometricAuthUseCase = RequestBiometricAuthUseCaseProtocolSpy()
//    allowBiometricUsageUseCase = AllowBiometricUsageUseCaseProtocolSpy()
//    onboardingSuccessUseCase = OnboardingSuccessUseCaseProtocolSpy()
//    updatePrivacyPolicyUseCase = UpdateAnalyticStatusUseCaseProtocolSpy()
//
//    viewModel = OnboardingViewModel(
//      routes: OnboardingRouter(),
//      getBiometricTypeUseCase: getBiometricTypeUseCase,
//      hasBiometricAuthUseCase: hasBiometricAuthUseCase,
//      registerPinCodeUseCase: registerPinCodeUseCase,
//      requestBiometricAuthUseCase: requestBiometricAuthUseCase,
//      allowBiometricUsageUseCase: allowBiometricUsageUseCase,
//      onboardingSuccessUseCase: onboardingSuccessUseCase,
//      updatePrivacyPolicyUseCase: updatePrivacyPolicyUseCase)
//  }
//
//  // MARK: Internal
//
//  func testWithInitialData() {
//    XCTAssertEqual(viewModel.currentIndex, OnboardingViewModel.Step.wallet.rawValue)
//    XCTAssertTrue(viewModel.isSwipeEnabled)
//    XCTAssertTrue(viewModel.isNextButtonEnabled)
//    XCTAssertEqual(viewModel.pageCount, OnboardingViewModel.Step.allCases.count)
//    XCTAssertTrue(viewModel.pin.isEmpty)
//    XCTAssertTrue(viewModel.confirmationPin.isEmpty)
//    XCTAssertEqual(viewModel.pinConfirmationState, .normal)
//    XCTAssertEqual(viewModel.biometricType, .faceID)
//    XCTAssertTrue(viewModel.hasBiometricAuth)
//
//    XCTAssertFalse(registerPinCodeUseCase.executePinCodeCalled)
//    XCTAssertFalse(requestBiometricAuthUseCase.executeReasonContextCalled)
//    XCTAssertFalse(allowBiometricUsageUseCase.executeAllowCalled)
//    XCTAssertFalse(onboardingSuccessUseCase.executeCalled)
//    XCTAssertTrue(getBiometricTypeUseCase.executeCalled)
//    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
//    XCTAssertFalse(updatePrivacyPolicyUseCase.executeIsAllowedCalled)
//  }
//
//  func testInitStepQrCode() {
//    viewModel.currentIndex = OnboardingViewModel.Step.qrCode.rawValue
//    XCTAssertTrue(viewModel.isSwipeEnabled)
//    XCTAssertTrue(viewModel.isNextButtonEnabled)
//  }
//
//  func testInitStepPrivacy() {
//    viewModel.currentIndex = OnboardingViewModel.Step.privacy.rawValue
//    XCTAssertTrue(viewModel.isSwipeEnabled)
//    XCTAssertTrue(viewModel.isNextButtonEnabled)
//  }
//
//  func testInitStepPin() {
//    viewModel.currentIndex = OnboardingViewModel.Step.pin.rawValue
//    XCTAssertFalse(viewModel.isSwipeEnabled)
//    XCTAssertFalse(viewModel.isNextButtonEnabled)
//  }
//
//  func testInitStepPinConfirmation() {
//    viewModel.currentIndex = OnboardingViewModel.Step.pinConfirmation.rawValue
//    XCTAssertFalse(viewModel.isSwipeEnabled)
//    XCTAssertFalse(viewModel.isNextButtonEnabled)
//  }
//
//  func testInitStepBiometrics() {
//    viewModel.currentIndex = OnboardingViewModel.Step.biometrics.rawValue
//    XCTAssertFalse(viewModel.isSwipeEnabled)
//    XCTAssertFalse(viewModel.isNextButtonEnabled)
//  }
//
//  func test_skipBiometrics() {
//    to(step: OnboardingViewModel.Step.biometrics, viewModel: viewModel)
//    viewModel.skipBiometrics()
//
//    XCTAssertTrue(registerPinCodeUseCase.executePinCodeCalled)
//    XCTAssertEqual(registerPinCodeUseCase.executePinCodeCallsCount, 1)
//    XCTAssertTrue(onboardingSuccessUseCase.executeCalled)
//    XCTAssertEqual(onboardingSuccessUseCase.executeCallsCount, 1)
//  }
//
//  func test_pinToConfirmation() async throws {
//    hasBiometricAuthUseCase.executeReturnValue = true
//    to(step: OnboardingViewModel.Step.pin, viewModel: viewModel)
//    viewModel.pin = "1234"
//    XCTAssertEqual(viewModel.currentIndex, OnboardingViewModel.Step.pin.rawValue)
//
//    viewModel.pin = pin
//    try await Task.sleep(nanoseconds: 1_100_000_000) // As the VM makes a delay on the user Input when there is 6 characters entered (currently 0.4s delay)
//    XCTAssertEqual(viewModel.currentIndex, OnboardingViewModel.Step.pinConfirmation.rawValue)
//  }
//
//  func test_pinConfirmation() async throws {
//    try await test_pinToConfirmation()
//
//    viewModel.confirmationPin = pin
//    try await Task.sleep(nanoseconds: 1_100_000_000)
//    XCTAssertEqual(viewModel.currentIndex, OnboardingViewModel.Step.biometrics.rawValue)
//  }
//
//  func test_pinConfirmation_withoutBiometrics() async throws {
//    try await test_pinToConfirmation()
//    hasBiometricAuthUseCase.executeReturnValue = false
//
//    viewModel.confirmationPin = pin
//    try await Task.sleep(nanoseconds: 1_100_000_000)
//    XCTAssertEqual(viewModel.currentIndex, OnboardingViewModel.Step.biometrics.rawValue)
//  }
//
//  func test_pinConfirmation1Failure() async throws {
//    try await test_pinToConfirmation()
//
//    viewModel.confirmationPin = "123412"
//    try await Task.sleep(nanoseconds: 1_100_000_000)
//    XCTAssertEqual(viewModel.currentIndex, OnboardingViewModel.Step.pinConfirmation.rawValue)
//  }
//
//  func test_pinConfirmationMultipleFailure_thenBackToPin() async throws {
//    try await test_pinToConfirmation()
//
//    viewModel.confirmationPin = "123412"
//    try await Task.sleep(nanoseconds: 1_100_000_000)
//
//    viewModel.confirmationPin = "123411"
//    try await Task.sleep(nanoseconds: 1_100_000_000)
//
//    viewModel.confirmationPin = "123451"
//    try await Task.sleep(nanoseconds: 1_100_000_000)
//
//    viewModel.confirmationPin = "123451"
//    try await Task.sleep(nanoseconds: 1_100_000_000)
//
//    viewModel.confirmationPin = "123451"
//    try await Task.sleep(nanoseconds: 2_000_000_000)
//
//    XCTAssertEqual(viewModel.currentIndex, OnboardingViewModel.Step.pin.rawValue)
//  }
//
//  func test_registerBiometrics() async throws {
//    to(step: OnboardingViewModel.Step.biometrics, viewModel: viewModel)
//    viewModel.registerBiometrics = true
//    try await Task.sleep(nanoseconds: 500_000_000)
//
//    XCTAssertTrue(requestBiometricAuthUseCase.executeReasonContextCalled)
//    XCTAssertEqual(requestBiometricAuthUseCase.executeReasonContextCallsCount, 1)
//    XCTAssertTrue(allowBiometricUsageUseCase.executeAllowCalled)
//    XCTAssertEqual(allowBiometricUsageUseCase.executeAllowCallsCount, 1)
//    XCTAssertTrue(registerPinCodeUseCase.executePinCodeCalled)
//    XCTAssertEqual(registerPinCodeUseCase.executePinCodeCallsCount, 1)
//    XCTAssertTrue(onboardingSuccessUseCase.executeCalled)
//    XCTAssertEqual(onboardingSuccessUseCase.executeCallsCount, 1)
//    XCTAssertTrue(getBiometricTypeUseCase.executeCalled)
//    XCTAssertEqual(getBiometricTypeUseCase.executeCallsCount, 1)
//    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
//    XCTAssertEqual(hasBiometricAuthUseCase.executeCallsCount, 1)
//  }
//
//  func testAcceptPrivacyPolicy() async {
//    await viewModel.acceptPrivacyPolicy()
//
//    XCTAssertTrue(updatePrivacyPolicyUseCase.executeIsAllowedCalled)
//    XCTAssertEqual(updatePrivacyPolicyUseCase.executeIsAllowedReceivedInvocations.first, true)
//  }
//
//  func testDeclinePrivacyPolicy() async {
//    await viewModel.declinePrivacyPolicy()
//
//    XCTAssertTrue(updatePrivacyPolicyUseCase.executeIsAllowedCalled)
//    XCTAssertEqual(updatePrivacyPolicyUseCase.executeIsAllowedReceivedInvocations.first, false)
//  }
//
//  // MARK: Private
//
//  // swiftlint:disable all
//  private var registerPinCodeUseCase: RegisterPinCodeUseCaseProtocolSpy!
//  private var hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocolSpy!
//  private var getBiometricTypeUseCase: GetBiometricTypeUseCaseProtocolSpy!
//  private var requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocolSpy!
//  private var allowBiometricUsageUseCase: AllowBiometricUsageUseCaseProtocolSpy!
//  private var onboardingSuccessUseCase: OnboardingSuccessUseCaseProtocolSpy!
//  private var updatePrivacyPolicyUseCase: UpdateAnalyticStatusUseCaseProtocolSpy!
//  private var viewModel: OnboardingViewModel!
//
//  private let pin: PinCode = "123456"
//
//  // swiftlint:enable all
//
//  private func to(step: OnboardingViewModel.Step, viewModel: OnboardingViewModel) {
//    viewModel.currentIndex = step.rawValue
//    XCTAssertEqual(viewModel.currentIndex, step.rawValue)
//  }
//
// }
