import BITCore
import BITDataStore
import Factory
import RealmSwift
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared

final class DatabaseCredentialRepositoryTests: XCTestCase {

  // MARK: Internal

  override class func setUp() {
    Container.shared.realmDataStoreConfiguration.register { Realm.Configuration(inMemoryIdentifier: "inMemory")
    }
  }

  override func setUp() {
    repository = RealmCredentialRepository()
  }

  // MARK: - Metadata

  func testCreateCredentialSuccess() async throws {
    let credential = try await repository.create(credential: .Mock.sample)
    let savedCredential = try await repository.get(id: credential.id)
    XCTAssertEqual(credential, savedCredential)
  }

  // MARK: Private

  // swiftlint:disable implicitly_unwrapped_optional
  private var repository: CredentialRepositoryProtocol!
  // swiftlint:enable implicitly_unwrapped_optional
}
