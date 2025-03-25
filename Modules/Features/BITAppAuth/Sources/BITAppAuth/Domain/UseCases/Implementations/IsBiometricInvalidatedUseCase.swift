import BITLocalAuthentication
import Factory
import Foundation

class IsBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocol {

  // MARK: Internal

  func execute() -> Bool {
    let exists = uniquePassphraseManager.exists(for: .biometric)
    return isBiometricUsageAllowed.execute()
      && hasBiometricAuth.execute()
      && !exists
  }

  // MARK: Private

  @Injected(\.isBiometricUsageAllowedUseCase) private var isBiometricUsageAllowed: IsBiometricUsageAllowedUseCaseProtocol
  @Injected(\.hasBiometricAuthUseCase) private var hasBiometricAuth: HasBiometricAuthUseCaseProtocol
  @Injected(\.uniquePassphraseManager) private var uniquePassphraseManager: UniquePassphraseManagerProtocol
}
