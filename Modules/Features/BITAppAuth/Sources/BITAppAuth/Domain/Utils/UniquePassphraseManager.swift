import BITCrypto
import BITLocalAuthentication
import Factory
import Foundation

struct UniquePassphraseManager: UniquePassphraseManagerProtocol {

  // MARK: Lifecycle

  init(
    isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol = Container.shared.isBiometricUsageAllowedUseCase(),
    uniquePassphraseRepository: UniquePassphraseRepositoryProtocol = Container.shared.uniquePassphraseRepository(),
    passphraseLength: Int = Container.shared.passphraseLength())
  {
    self.isBiometricUsageAllowedUseCase = isBiometricUsageAllowedUseCase
    self.uniquePassphraseRepository = uniquePassphraseRepository
    self.passphraseLength = passphraseLength
  }

  // MARK: Internal

  func generate() throws -> Data {
    try Data.random(length: passphraseLength)
  }

  func save(uniquePassphrase: Data, context: LAContextProtocol) throws {
    try uniquePassphraseRepository.saveUniquePassphrase(uniquePassphrase, forAuthMethod: .appPin, inContext: context)
    if isBiometricUsageAllowedUseCase.execute() {
      try uniquePassphraseRepository.saveUniquePassphrase(uniquePassphrase, forAuthMethod: .biometric, inContext: context)
    }
  }

  func save(uniquePassphrase: Data, for authMethod: AuthMethod, context: LAContextProtocol) throws {
    try uniquePassphraseRepository.saveUniquePassphrase(uniquePassphrase, forAuthMethod: authMethod, inContext: context)
  }

  func exists(for authMethod: AuthMethod) -> Bool {
    uniquePassphraseRepository.hasUniquePassphraseSaved(forAuthMethod: authMethod)
  }

  func getUniquePassphrase(authMethod: AuthMethod, context: LAContextProtocol) throws -> Data {
    try uniquePassphraseRepository.getUniquePassphrase(forAuthMethod: authMethod, inContext: context)
  }

  func deleteBiometricUniquePassphrase() throws {
    try uniquePassphraseRepository.deleteBiometricUniquePassphrase()
  }

  // MARK: Private

  private let isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol
  private let uniquePassphraseRepository: UniquePassphraseRepositoryProtocol
  private let passphraseLength: Int

}
