import Foundation
import RealmSwift

public class EIDRequestCaseEntity: Object {

  @Persisted(primaryKey: true) public var id: String
  @Persisted public var rawMRZ: String
  @Persisted public var documentNumber: String
  @Persisted public var lastName: String
  @Persisted public var firstName: String
  @Persisted public var createdAt: Date
  @Persisted public var state: EIDRequestStateEntity?
}
