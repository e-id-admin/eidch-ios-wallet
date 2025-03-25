import BITCrypto
import BITDataStore
import BITLocalAuthentication
import Factory
import Foundation
import LocalAuthentication

public class RegisterPinCodeUseCase: RegisterPinCodeUseCaseProtocol {

  // MARK: Public

  public func execute(pinCode: PinCode) throws {
    try saltService.generateSalt()
    try pepperService.generatePepper()
    let pinCodeDataEncrypted = try pinCodeManager.encrypt(pinCode)

    guard internalContext.setCredential(pinCodeDataEncrypted, type: .applicationPassword) else {
      throw AuthError.LAContextError(reason: "Register pincode context setCredential failed.")
    }

    let uniquePassphrase = try uniquePassphraseManager.generate()
    try saveUniquePassphrase(uniquePassphrase, context: internalContext)

    try userSession.startSession(passphrase: uniquePassphrase)

    dataStoreConfigurationManager.setEncryption(key: uniquePassphrase)
  }

  // MARK: Private

  @Injected(\.pinCodeManager) private var pinCodeManager: PinCodeManagerProtocol
  @Injected(\.saltService) private var saltService: SaltServiceProtocol
  @Injected(\.pepperService) private var pepperService: PepperServiceProtocol
  @Injected(\.uniquePassphraseManager) private var uniquePassphraseManager: UniquePassphraseManagerProtocol
  @Injected(\.isBiometricUsageAllowedUseCase) private var isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol
  @Injected(\.userSession) private var userSession: Session
  @Injected(\.dataStoreConfigurationManager) private var dataStoreConfigurationManager: DataStoreConfigurationManagerProtocol
  @Injected(\.internalContext) private var internalContext: LAContextProtocol

  private func saveUniquePassphrase(_ uniquePassphrase: Data, context: LAContextProtocol) throws {
    try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .appPin, context: context)

    if isBiometricUsageAllowedUseCase.execute() {
      try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .biometric, context: context)
    }
  }

}
