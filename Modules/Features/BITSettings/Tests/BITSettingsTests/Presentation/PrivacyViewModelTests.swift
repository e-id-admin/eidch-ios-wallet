import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITSettings

final class PrivacyViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    hasBiometricAuthUseCase = HasBiometricAuthUseCaseProtocolSpy()
    hasBiometricAuthUseCase.executeReturnValue = true

    isBiometricUsageAllowedUseCase = IsBiometricUsageAllowedUseCaseProtocolSpy()
    isBiometricUsageAllowedUseCase.executeReturnValue = true

    updateAnalyticStatusUseCase = UpdateAnalyticStatusUseCaseProtocolSpy()
    fetchAnalyticStatusUseCase = FetchAnalyticStatusUseCaseProtocolSpy()
    fetchAnalyticStatusUseCase.executeReturnValue = true

    viewModel = PrivacyViewModel(
      hasBiometricAuthUseCase: hasBiometricAuthUseCase,
      isBiometricUsageAllowedUseCase: isBiometricUsageAllowedUseCase,
      updateAnalyticStatusUseCase: updateAnalyticStatusUseCase,
      fetchAnalyticStatusUseCase: fetchAnalyticStatusUseCase)
  }

  func testInitialState() {
    XCTAssertFalse(viewModel.isBiometricEnabled)
    XCTAssertFalse(viewModel.isAnalyticsEnabled)
    XCTAssertFalse(viewModel.isChangePinCodePresented)
    XCTAssertFalse(viewModel.isBiometricChangeFlowPresented)
    XCTAssertFalse(viewModel.isInformationPresented)
    XCTAssertFalse(viewModel.isLoading)
  }

  func testFetchBiometricStatus_enabled() {
    isBiometricUsageAllowedUseCase.executeReturnValue = true
    hasBiometricAuthUseCase.executeReturnValue = true

    viewModel.fetchBiometricStatus()

    XCTAssertTrue(viewModel.isBiometricEnabled)
    XCTAssertFalse(viewModel.isAnalyticsEnabled)
    XCTAssertFalse(viewModel.isChangePinCodePresented)
    XCTAssertFalse(viewModel.isBiometricChangeFlowPresented)
    XCTAssertFalse(viewModel.isInformationPresented)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertTrue(isBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
  }

  func testFetchBiometricStatus_disabled() {
    isBiometricUsageAllowedUseCase.executeReturnValue = false
    hasBiometricAuthUseCase.executeReturnValue = true

    viewModel.fetchBiometricStatus()

    XCTAssertFalse(viewModel.isBiometricEnabled)
    XCTAssertFalse(viewModel.isAnalyticsEnabled)
    XCTAssertFalse(viewModel.isChangePinCodePresented)
    XCTAssertFalse(viewModel.isBiometricChangeFlowPresented)
    XCTAssertFalse(viewModel.isInformationPresented)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertTrue(isBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertFalse(hasBiometricAuthUseCase.executeCalled)
  }

  func testPresentBiometricChangeFlow() {
    viewModel.presentBiometricChangeFlow()

    XCTAssertTrue(viewModel.isBiometricChangeFlowPresented)
  }

  func testPresentPinChangeFlow() {
    viewModel.presentPinChangeFlow()

    XCTAssertTrue(viewModel.isChangePinCodePresented)
  }

  func testPresentInformationView() {
    viewModel.presentInformationView()

    XCTAssertTrue(viewModel.isInformationPresented)
  }

  func testFetchAnalyticsStatus_enabled() {
    fetchAnalyticStatusUseCase.executeReturnValue = true

    viewModel.fetchAnalyticsStatus()

    XCTAssertFalse(viewModel.isBiometricEnabled)
    XCTAssertTrue(viewModel.isAnalyticsEnabled)
    XCTAssertFalse(viewModel.isChangePinCodePresented)
    XCTAssertFalse(viewModel.isBiometricChangeFlowPresented)
    XCTAssertFalse(viewModel.isInformationPresented)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertTrue(fetchAnalyticStatusUseCase.executeCalled)
  }

  func testFetchAnalyticsStatus_disabled() {
    fetchAnalyticStatusUseCase.executeReturnValue = false

    viewModel.fetchAnalyticsStatus()

    XCTAssertFalse(viewModel.isBiometricEnabled)
    XCTAssertFalse(viewModel.isAnalyticsEnabled)
    XCTAssertFalse(viewModel.isChangePinCodePresented)
    XCTAssertFalse(viewModel.isBiometricChangeFlowPresented)
    XCTAssertFalse(viewModel.isInformationPresented)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertTrue(fetchAnalyticStatusUseCase.executeCalled)
  }

  func testUpdateAnalyticsStatus() async {
    let isAnalyticsEnabbled = viewModel.isAnalyticsEnabled

    await viewModel.updateAnalyticsStatus()

    XCTAssertTrue(updateAnalyticStatusUseCase.executeIsAllowedCalled)
    XCTAssertEqual(viewModel.isAnalyticsEnabled, !isAnalyticsEnabbled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: PrivacyViewModel!
  private var hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocolSpy!
  private var isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocolSpy!
  private var fetchAnalyticStatusUseCase: FetchAnalyticStatusUseCaseProtocolSpy!
  private var updateAnalyticStatusUseCase: UpdateAnalyticStatusUseCaseProtocolSpy!
  // swiftlint:enable all
}
