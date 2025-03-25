import BITL10n
import BITLocalAuthentication
import Factory
import Foundation
import LocalAuthentication

// MARK: - ChangeBiometricStatusError

enum ChangeBiometricStatusError: String, Error, CustomStringConvertible {
  case userCancel
  case biometricRetry

  var description: String {
    rawValue
  }
}

// MARK: - ChangeBiometricStatusUseCase

struct ChangeBiometricStatusUseCase: ChangeBiometricStatusUseCaseProtocol {

  // MARK: Internal

  func execute(with uniquePassphrase: Data) async throws {
    let isBiometricEnabled = isBiometricUsageAllowedUseCase.execute() && hasBiometricAuthUseCase.execute()

    if isBiometricEnabled {
      try disableBiometrics()
    } else {
      try await enableBiometrics(uniquePassphrase: uniquePassphrase)
    }
  }

  // MARK: Private

  @Injected(\.userSession) private var userSession: Session
  @Injected(\.uniquePassphraseManager) private var uniquePassphraseManager: UniquePassphraseManagerProtocol
  @Injected(\.requestBiometricAuthUseCase) private var requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol
  @Injected(\.allowBiometricUsageUseCase) private var allowBiometricUsageUseCase: AllowBiometricUsageUseCaseProtocol
  @Injected(\.hasBiometricAuthUseCase) private var hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol
  @Injected(\.isBiometricUsageAllowedUseCase) private var isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol

  private func enableBiometrics(uniquePassphrase: Data) async throws {
    guard userSession.isLoggedIn, let context = userSession.context else {
      throw UserSessionError.notLoggedIn
    }

    do {
      try await requestBiometricAuthUseCase.execute(reason: L10n.biometricSetupReason, context: context)
    } catch LAError.userCancel {
      throw ChangeBiometricStatusError.userCancel
    }

    try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .biometric, context: context)
    try allowBiometricUsageUseCase.execute(allow: true)
  }

  private func disableBiometrics() throws {
    try uniquePassphraseManager.deleteBiometricUniquePassphrase()
    try allowBiometricUsageUseCase.execute(allow: false)
  }
}
