import BITCredentialShared
import Foundation
import Spyable

@Spyable
public protocol CredentialRepositoryProtocol {
  func create(credential: Credential) async throws -> Credential
  func getAll() async throws -> [Credential]
  func get(id: UUID) async throws -> Credential
  @discardableResult
  func update(_ credential: Credential) async throws -> Credential
  func delete(_ id: UUID) async throws
  func count() throws -> Int
}
