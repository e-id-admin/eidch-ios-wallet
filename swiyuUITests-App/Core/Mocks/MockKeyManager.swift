import BITVault
import Security
@testable import BITTestingCore

struct MockKeyManager: KeyManagerProtocol {
  func generateKeyPair(withIdentifier identifier: String, algorithm: VaultAlgorithm, options: VaultOption, query: Query?) throws -> SecKey {
    SecKeyTestsHelper.createPrivateKey(size: algorithm.size)
  }

  func deleteKeyPair(withIdentifier identifier: String, algorithm: VaultAlgorithm) throws {

  }

  func getPublicKey(for privateKey: SecKey) throws -> SecKey {
    SecKeyTestsHelper.createPrivateKey()
  }

  func getPublicKey(withIdentifier identifier: String, algorithm: VaultAlgorithm, query: Query?) throws -> SecKey {
    SecKeyTestsHelper.createPrivateKey(size: algorithm.size)
  }

  func getPrivateKey(withIdentifier identifier: String, algorithm: VaultAlgorithm, query: Query?) throws -> SecKey {
    SecKeyTestsHelper.createPrivateKey(size: algorithm.size)
  }
}
