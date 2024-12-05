import BITAppAuth
import BITCrypto
import BITLocalAuthentication
import BITVault
import Factory
import Foundation

// MARK: - CredentialJWTGenerator

struct CredentialKeyPairGenerator: CredentialKeyPairGeneratorProtocol {

  // MARK: Lifecycle

  init(
    keyManager: KeyManagerProtocol = Container.shared.keyManager(),
    vaultAccessControlFlags: SecAccessControlCreateFlags = Container.shared.vaultAccessControlFlags(),
    vaultProtection: CFString = Container.shared.vaultProtection(),
    vaultOptions: VaultOption = Container.shared.vaultOptions(),
    context: LAContextProtocol = Container.shared.authContext())
  {
    self.keyManager = keyManager
    self.vaultAccessControlFlags = vaultAccessControlFlags
    self.vaultProtection = vaultProtection
    self.vaultOptions = vaultOptions
    self.context = context
  }

  // MARK: Internal

  enum CredentialKeyPairGeneratorError: Error {
    case invalidAlgorithm
  }

  func generate(identifier: UUID, algorithm: String) throws -> KeyPair {
    let query = try QueryBuilder()
      .setAccessControlFlags(vaultAccessControlFlags)
      .setProtection(vaultProtection)
      .setContext(context)
      .build()

    guard let vaultAlgorithm = VaultAlgorithm(rawValue: algorithm) else {
      throw CredentialKeyPairGeneratorError.invalidAlgorithm
    }

    let key = try keyManager.generateKeyPair(
      withIdentifier: identifier.uuidString,
      algorithm: vaultAlgorithm,
      options: vaultOptions,
      query: query)
    return KeyPair(identifier: identifier, algorithm: vaultAlgorithm.rawValue, privateKey: key)
  }

  // MARK: Private

  private let keyManager: KeyManagerProtocol
  private let vaultAccessControlFlags: SecAccessControlCreateFlags
  private let vaultProtection: CFString
  private let vaultOptions: VaultOption
  private let context: LAContextProtocol

}
