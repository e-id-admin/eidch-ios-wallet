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

  // MARK: Lifecycle

  init(
    requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol = Container.shared.requestBiometricAuthUseCase(),
    uniquePassphraseManager: UniquePassphraseManagerProtocol = Container.shared.uniquePassphraseManager(),
    allowBiometricUsageUseCase: AllowBiometricUsageUseCaseProtocol = Container.shared.allowBiometricUsageUseCase(),
    hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol = Container.shared.hasBiometricAuthUseCase(),
    isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol = Container.shared.isBiometricUsageAllowedUseCase(),
    context: LAContextProtocol = Container.shared.authContext())
  {
    self.requestBiometricAuthUseCase = requestBiometricAuthUseCase
    self.uniquePassphraseManager = uniquePassphraseManager
    self.allowBiometricUsageUseCase = allowBiometricUsageUseCase
    self.hasBiometricAuthUseCase = hasBiometricAuthUseCase
    self.isBiometricUsageAllowedUseCase = isBiometricUsageAllowedUseCase
    self.context = context
  }

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

  private let context: LAContextProtocol
  private let uniquePassphraseManager: UniquePassphraseManagerProtocol
  private var requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol
  private var allowBiometricUsageUseCase: AllowBiometricUsageUseCaseProtocol
  private var hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol
  private var isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol

  private func enableBiometrics(uniquePassphrase: Data) async throws {
    do {
      try await requestBiometricAuthUseCase.execute(reason: L10n.biometricSetupReason, context: LAContext())
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
