import BITLocalAuthentication
import Factory
import Foundation

class IsBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocol {

  // MARK: Lifecycle

  init(
    isBiometricUsageAllowed: IsBiometricUsageAllowedUseCaseProtocol = Container.shared.isBiometricUsageAllowedUseCase(),
    hasBiometricAuth: HasBiometricAuthUseCaseProtocol = Container.shared.hasBiometricAuthUseCase(),
    uniquePassphraseManager: UniquePassphraseManagerProtocol = Container.shared.uniquePassphraseManager())
  {
    self.isBiometricUsageAllowed = isBiometricUsageAllowed
    self.hasBiometricAuth = hasBiometricAuth
    self.uniquePassphraseManager = uniquePassphraseManager
  }

  // MARK: Internal

  func execute() -> Bool {
    let exists = uniquePassphraseManager.exists(for: .biometric)
    return isBiometricUsageAllowed.execute()
      && hasBiometricAuth.execute()
      && !exists
  }

  // MARK: Private

  private let isBiometricUsageAllowed: IsBiometricUsageAllowedUseCaseProtocol
  private let hasBiometricAuth: HasBiometricAuthUseCaseProtocol
  private let uniquePassphraseManager: UniquePassphraseManagerProtocol
}
