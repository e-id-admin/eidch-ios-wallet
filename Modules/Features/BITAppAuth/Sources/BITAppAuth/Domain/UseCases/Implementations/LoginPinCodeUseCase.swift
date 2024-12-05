import BITDataStore
import BITLocalAuthentication
import Factory
import Foundation

struct LoginPinCodeUseCase: LoginPinCodeUseCaseProtocol {

  // MARK: Lifecycle

  init(
    getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol = Container.shared.getUniquePassphraseUseCase(),
    isBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocol = Container.shared.isBiometricInvalidatedUseCase(),
    uniquePassphraseManager: UniquePassphraseManagerProtocol = Container.shared.uniquePassphraseManager(),
    contextManager: ContextManagerProtocol = Container.shared.contextManager(),
    context: LAContextProtocol = Container.shared.authContext(),
    dataStoreConfigurationManager: DataStoreConfigurationManagerProtocol = Container.shared.dataStoreConfigurationManager())
  {
    self.getUniquePassphraseUseCase = getUniquePassphraseUseCase
    self.isBiometricInvalidatedUseCase = isBiometricInvalidatedUseCase
    self.uniquePassphraseManager = uniquePassphraseManager
    self.context = context
    self.contextManager = contextManager
    self.dataStoreConfigurationManager = dataStoreConfigurationManager
  }

  // MARK: Internal

  func execute(from pinCode: PinCode) throws {
    let uniquePassphrase = try getUniquePassphraseUseCase.execute(from: pinCode)
    try contextManager.setCredential(uniquePassphrase, context: context)
    if isBiometricInvalidatedUseCase.execute() {
      try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .biometric, context: context)
    }
    dataStoreConfigurationManager.setEncryption(key: uniquePassphrase)

    NotificationCenter.default.post(name: .didLogin, object: nil)
  }

  // MARK: Private

  private let getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol
  private let isBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocol
  private let uniquePassphraseManager: UniquePassphraseManagerProtocol
  private let context: LAContextProtocol
  private let contextManager: ContextManagerProtocol
  private let dataStoreConfigurationManager: DataStoreConfigurationManagerProtocol
}
