import BITAppAuth
import BITL10n
import Factory
import Foundation

// MARK: - PrivacyViewModel

class PrivacyViewModel: ObservableObject {

  // MARK: Lifecycle

  public init(
    hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol = Container.shared.hasBiometricAuthUseCase(),
    isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol = Container.shared.isBiometricUsageAllowedUseCase(),
    updateAnalyticStatusUseCase: UpdateAnalyticStatusUseCaseProtocol = Container.shared.updateAnalyticsStatusUseCase(),
    fetchAnalyticStatusUseCase: FetchAnalyticStatusUseCaseProtocol = Container.shared.fetchAnalyticStatusUseCase())
  {
    self.hasBiometricAuthUseCase = hasBiometricAuthUseCase
    self.isBiometricUsageAllowedUseCase = isBiometricUsageAllowedUseCase
    self.updateAnalyticStatusUseCase = updateAnalyticStatusUseCase
    self.fetchAnalyticStatusUseCase = fetchAnalyticStatusUseCase
  }

  // MARK: Internal

  @Published var isBiometricEnabled: Bool = false
  @Published var isAnalyticsEnabled: Bool = false

  @Published var isChangePinCodePresented = false
  @Published var isInformationPresented: Bool = false
  @Published var isBiometricChangeFlowPresented: Bool = false

  @Published var isLoading: Bool = false
  @Published var isToastPresented: Bool = false
  @Published var toastMessage: String?

  func fetchBiometricStatus() {
    isBiometricEnabled = (isBiometricUsageAllowedUseCase.execute() && hasBiometricAuthUseCase.execute())
  }

  func fetchAnalyticsStatus() {
    isAnalyticsEnabled = fetchAnalyticStatusUseCase.execute()
  }

  func presentPinChangeFlow() {
    isChangePinCodePresented = true
  }

  func presentBiometricChangeFlow() {
    isBiometricChangeFlowPresented = true
  }

  func presentInformationView() {
    isInformationPresented = true
  }

  @MainActor
  func updateAnalyticsStatus() async {
    isLoading = true
    let newStatus = !isAnalyticsEnabled
    await updateAnalyticStatusUseCase.execute(isAllowed: newStatus)

    isAnalyticsEnabled = newStatus
    isLoading = false
  }

  func clearToast() {
    toastMessage = nil
  }

  // MARK: Private

  private var hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol
  private var isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol
  private var fetchAnalyticStatusUseCase: FetchAnalyticStatusUseCaseProtocol
  private var updateAnalyticStatusUseCase: UpdateAnalyticStatusUseCaseProtocol

}

// MARK: ChangePinCodeDelegate

extension PrivacyViewModel: ChangePinCodeDelegate {

  public func didChangePinCode() {
    toastMessage = L10n.tkChangepasswordSuccessfulNotification
    isToastPresented = true
  }

}

// MARK: BiometricChangeDelegate

extension PrivacyViewModel: BiometricChangeDelegate {

  func didBiometricStatusChange(to isEnabled: Bool) {
    toastMessage = isEnabled ? L10n.tkMenuSecurityPrivacyIosStatusActivating : L10n.tkMenuSecurityPrivacyIosStatusDeactivating
    isToastPresented = true
  }

}
