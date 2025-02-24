import Foundation
import RealmSwift

public class EIDRequestStateEntity: Object {

  @Persisted(primaryKey: true) public var id: UUID
  @Persisted public var state: String
  @Persisted public var lastPolledAt: Date
  @Persisted public var onlineSessionStartOpenAt: Date?
  @Persisted public var onlineSessionStartTimeoutAt: Date?
}
