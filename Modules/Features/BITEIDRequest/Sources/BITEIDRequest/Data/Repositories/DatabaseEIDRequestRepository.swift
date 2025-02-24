import BITDataStore
import BITEntities
import Factory
import Foundation


enum DatabaseEIDRequestRepositoryError: Error {
  case notFound
}


struct DatabaseEIDRequestRepository: LocalEIDRequestRepositoryProtocol {

  // MARK: Internal

  func create(eIDRequestCase: EIDRequestCase) async throws -> EIDRequestCase {
    let entity = EIDRequestCaseEntity(eIDRequestCase)
    try database.save(entity)
    return try EIDRequestCase(entity)
  }

  func get(id: String) async throws -> EIDRequestCase {
    let entity = try await getEntity(id)
    return try EIDRequestCase(entity)
  }

  // MARK: Private

  @Injected(\.dataStore) private var database: RealmDataStoreProtocol

  private func getEntity(_ id: String) async throws -> EIDRequestCaseEntity {
    let results = try database.get(EIDRequestCaseEntity.self, forPrimaryKey: id)
    guard let entity = results else { throw DatabaseEIDRequestRepositoryError.notFound }
    return entity
  }

}
