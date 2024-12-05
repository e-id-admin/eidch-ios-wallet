import BITLocalAuthentication
import Foundation
import Spyable

@Spyable
public protocol UniquePassphraseManagerProtocol {
  func generate() throws -> Data
  func save(uniquePassphrase: Data, for authMethod: AuthMethod, context: LAContextProtocol) throws
  func exists(for authMethod: AuthMethod) -> Bool
  func deleteBiometricUniquePassphrase() throws
  @discardableResult
  func getUniquePassphrase(authMethod: AuthMethod, context: LAContextProtocol) throws -> Data
}
