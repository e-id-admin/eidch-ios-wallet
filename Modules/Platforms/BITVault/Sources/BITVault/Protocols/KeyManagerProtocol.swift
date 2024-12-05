import Foundation
import Spyable

// MARK: - KeyManagerProtocol

@Spyable
public protocol KeyManagerProtocol {
  @discardableResult
  func generateKeyPair(withIdentifier identifier: String, algorithm: VaultAlgorithm, options: VaultOption, query: Query?) throws -> SecKey
  func deleteKeyPair(withIdentifier identifier: String, algorithm: VaultAlgorithm) throws
  func getPrivateKey(withIdentifier identifier: String, algorithm: VaultAlgorithm, query: Query?) throws -> SecKey
  func getPublicKey(for privateKey: SecKey) throws -> SecKey
  func getPublicKey(withIdentifier identifier: String, algorithm: VaultAlgorithm, query: Query?) throws -> SecKey
}

extension KeyManagerProtocol {

  public func getPrivateKey(withIdentifier identifier: String, algorithm: VaultAlgorithm) throws -> SecKey {
    try getPrivateKey(withIdentifier: identifier, algorithm: algorithm, query: nil)
  }
}
