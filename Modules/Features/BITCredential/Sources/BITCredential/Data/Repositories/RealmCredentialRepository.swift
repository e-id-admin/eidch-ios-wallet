import BITCredentialShared
import BITDataStore
import BITEntities
import BITJWT
import Factory
import Foundation

// MARK: - CredentialRepositoryError

enum CredentialRepositoryError: Error {
  case notFound
  case invalidEntity
}

// MARK: - RealmCredentialRepository

struct RealmCredentialRepository: CredentialRepositoryProtocol {

  // MARK: Public

  public func create(credential: Credential) async throws -> Credential {
    let entity = CredentialEntity(credential: credential)
    try database.save(entity)
    return Credential(entity)
  }

  public func get(id: UUID) async throws -> Credential {
    let entity = try await getEntity(id)
    return Credential(entity)
  }

  @discardableResult
  public func update(_ credential: Credential) async throws -> Credential {
    let entity = try await getEntity(credential.id)
    try database.write({
      entity.setValues(from: credential)
    })
    return Credential(entity)
  }

  public func delete(_ id: UUID) async throws {
    let entity = try await getEntity(id)
    try database.delete(entity)
  }

  public func getAll() async throws -> [Credential] {
    let results = try database.get(CredentialEntity.self)
    let entities = results.sorted(by: \.createdAt, ascending: false)
    return entities.map { .init($0) }
  }

  public func count() throws -> Int {
    try database.get(CredentialEntity.self).count
  }

  // MARK: Internal

  let database: RealmDataStoreProtocol = Container.shared.dataStore()

  func getEntity(_ id: UUID) async throws -> CredentialEntity {
    let results = try database.get(CredentialEntity.self, forPrimaryKey: id)
    guard let entity = results else { throw CredentialRepositoryError.notFound }
    return entity
  }

}
