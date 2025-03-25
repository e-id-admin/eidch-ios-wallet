import BITAppAuth
import BITCrypto
import BITLocalAuthentication
import BITVault
import Factory
import Foundation

// MARK: - CredentialJWTGenerator

struct CredentialKeyPairGenerator: CredentialKeyPairGeneratorProtocol {

  // MARK: Internal

  enum CredentialKeyPairGeneratorError: Error {
    case invalidAlgorithm
  }

  func generate(identifier: UUID, algorithm: String) throws -> KeyPair {
    guard
      userSession.isLoggedIn,
      let context = userSession.context
    else {
      throw UserSessionError.notLoggedIn
    }

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

  @Injected(\.keyManager) private var keyManager: KeyManagerProtocol
  @Injected(\.vaultAccessControlFlags) private var vaultAccessControlFlags: SecAccessControlCreateFlags
  @Injected(\.vaultProtection) private var vaultProtection: CFString
  @Injected(\.vaultOptions) private var vaultOptions: VaultOption
  @Injected(\.userSession) private var userSession: Session

}
