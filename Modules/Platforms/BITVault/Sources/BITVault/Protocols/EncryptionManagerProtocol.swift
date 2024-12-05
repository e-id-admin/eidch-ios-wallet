import Foundation
import Spyable

// MARK: - EncryptionManagerProtocol

@Spyable
public protocol EncryptionManagerProtocol {
  func encrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, query: Query?) throws -> Data
  func decrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, query: Query?) throws -> Data
}

extension EncryptionManagerProtocol {

  public func encrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, query: Query? = nil) throws -> Data {
    try encrypt(data: data, withIdentifier: identifier, algorithm: algorithm, query: query)
  }

  public func decrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, query: Query? = nil) throws -> Data {
    try decrypt(data: data, withIdentifier: identifier, algorithm: algorithm, query: query)
  }

}
