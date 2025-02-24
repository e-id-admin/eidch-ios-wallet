import Factory
import RealmSwift
import XCTest
@testable import BITEIDRequest

final class DatabaseEIDRequestRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    Container.shared.realmDataStoreConfiguration.register { Realm.Configuration(inMemoryIdentifier: "inMemory") }
    repository = DatabaseEIDRequestRepository()
  }

  // MARK: - Metadata

  func testCreateEIDRequestCaseSuccess() async throws {
    let eIDRequestCase = try await repository.create(eIDRequestCase: .Mock.sampleInQueue)
    let savedRequestCase = try await repository.get(id: eIDRequestCase.id)
    XCTAssertEqual(eIDRequestCase, savedRequestCase)
  }

  // MARK: Private

  // swiftlint:disable implicitly_unwrapped_optional
  private var repository: LocalEIDRequestRepositoryProtocol!
  // swiftlint:enable implicitly_unwrapped_optional
}
