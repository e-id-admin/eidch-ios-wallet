import Foundation
import RealmSwift

// MARK: - CredentialClaimEntity

public class CredentialClaimEntity: Object {

  @Persisted(primaryKey: true) public var id: UUID
  @Persisted public var key: String
  @Persisted public var order: Int16
  @Persisted public var value: String
  @Persisted public var valueType: String
  @Persisted public var displays = List<CredentialClaimDisplayEntity>()

  @Persisted(originProperty: "claims")
  public var credential: LinkingObjects<CredentialEntity>

}
