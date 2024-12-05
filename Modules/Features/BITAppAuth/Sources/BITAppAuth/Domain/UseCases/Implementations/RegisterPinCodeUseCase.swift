import BITCrypto
import BITDataStore
import BITLocalAuthentication
import Factory
import Foundation

public class RegisterPinCodeUseCase: RegisterPinCodeUseCaseProtocol {

  // MARK: Lifecycle

  public init(
    pinCodeManager: PinCodeManagerProtocol = Container.shared.pinCodeManager(),
    saltService: SaltServiceProtocol = Container.shared.saltService(),
    pepperService: PepperServiceProtocol = Container.shared.pepperService(),
    uniquePassphraseManager: UniquePassphraseManagerProtocol = Container.shared.uniquePassphraseManager(),
    isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol = Container.shared.isBiometricUsageAllowedUseCase(),
    contextManager: ContextManagerProtocol = Container.shared.contextManager(),
    context: LAContextProtocol = Container.shared.authContext(),
    dataStoreConfigurationManager: DataStoreConfigurationManagerProtocol = Container.shared.dataStoreConfigurationManager())
  {
    self.pinCodeManager = pinCodeManager
    self.saltService = saltService
    self.pepperService = pepperService
    self.uniquePassphraseManager = uniquePassphraseManager
    self.contextManager = contextManager
    self.context = context
    self.isBiometricUsageAllowedUseCase = isBiometricUsageAllowedUseCase
    self.dataStoreConfigurationManager = dataStoreConfigurationManager
  }

  // MARK: Public

  public func execute(pinCode: PinCode) throws {
    try saltService.generateSalt()
    try pepperService.generatePepper()
    let pinCodeDataEncrypted = try pinCodeManager.encrypt(pinCode)
    try contextManager.setCredential(pinCodeDataEncrypted, context: context)

    let uniquePassphrase = try uniquePassphraseManager.generate()
    try saveUniquePassphrase(uniquePassphrase, context: context)
    try contextManager.setCredential(uniquePassphrase, context: context)

    dataStoreConfigurationManager.setEncryption(key: uniquePassphrase)
  }

  // MARK: Private

  private let pinCodeManager: PinCodeManagerProtocol
  private let saltService: SaltServiceProtocol
  private let pepperService: PepperServiceProtocol
  private let uniquePassphraseManager: UniquePassphraseManagerProtocol
  private let isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol
  private let contextManager: ContextManagerProtocol
  private let context: LAContextProtocol
  private let dataStoreConfigurationManager: DataStoreConfigurationManagerProtocol

  private func saveUniquePassphrase(_ uniquePassphrase: Data, context: LAContextProtocol) throws {
    try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .appPin, context: context)

    if isBiometricUsageAllowedUseCase.execute() {
      try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .biometric, context: context)
    }
  }

}
