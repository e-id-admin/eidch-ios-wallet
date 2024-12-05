import BITDataStore
import BITL10n
import BITLocalAuthentication
import Factory
import Foundation

// MARK: - LoginBiometricUseCase

class LoginBiometricUseCase: LoginBiometricUseCaseProtocol {

  // MARK: Lifecycle

  init(
    requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol = Container.shared.requestBiometricAuthUseCase(),
    uniquePassphraseManager: UniquePassphraseManagerProtocol = Container.shared.uniquePassphraseManager(),
    contextManager: ContextManagerProtocol = Container.shared.contextManager(),
    context: LAContextProtocol = Container.shared.authContext(),
    dataStoreConfigurationManager: DataStoreConfigurationManagerProtocol = Container.shared.dataStoreConfigurationManager())
  {
    self.requestBiometricAuthUseCase = requestBiometricAuthUseCase
    self.uniquePassphraseManager = uniquePassphraseManager
    self.contextManager = contextManager
    self.context = context
    self.dataStoreConfigurationManager = dataStoreConfigurationManager
  }

  // MARK: Internal

  func execute() async throws {
    try await requestBiometricAuthUseCase.execute(reason: L10n.biometricSetupReason, context: context)
    let uniquePassphrase = try uniquePassphraseManager.getUniquePassphrase(authMethod: .biometric, context: context)
    try contextManager.setCredential(uniquePassphrase, context: context)
    dataStoreConfigurationManager.setEncryption(key: uniquePassphrase)

    NotificationCenter.default.post(name: .didLogin, object: nil)
  }

  // MARK: Private

  private let requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol
  private let uniquePassphraseManager: UniquePassphraseManagerProtocol
  private let contextManager: ContextManagerProtocol
  private let context: LAContextProtocol
  private let dataStoreConfigurationManager: DataStoreConfigurationManagerProtocol
}
