import BITDataStore
import BITLocalAuthentication
import Factory
import Foundation

struct LoginPinCodeUseCase: LoginPinCodeUseCaseProtocol {

  // MARK: Internal

  func execute(from pinCode: PinCode) throws {
    let uniquePassphrase = try getUniquePassphraseUseCase.execute(from: pinCode)
    let context = try userSession.startSession(passphrase: uniquePassphrase)

    if isBiometricInvalidatedUseCase.execute() {
      try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .biometric, context: context)
    }
    dataStoreConfigurationManager.setEncryption(key: uniquePassphrase)

    NotificationCenter.default.post(name: .didLogin, object: nil)
  }

  // MARK: Private

  @Injected(\.getUniquePassphraseUseCase) private var getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol
  @Injected(\.isBiometricInvalidatedUseCase) private var isBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocol
  @Injected(\.uniquePassphraseManager) private var uniquePassphraseManager: UniquePassphraseManagerProtocol
  @Injected(\.dataStoreConfigurationManager) private var dataStoreConfigurationManager: DataStoreConfigurationManagerProtocol
  @Injected(\.userSession) private var userSession: Session
}
