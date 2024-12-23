import Foundation
import RealmSwift

// MARK: - CredentialIssuerDisplayEntity

public class CredentialIssuerDisplayEntity: Object {

  @Persisted(primaryKey: true) public var id: UUID
  @Persisted public var locale: String?
  @Persisted public var name: String?
  @Persisted public var image: Data?

  @Persisted(originProperty: "issuerDisplays")
  public var credential: LinkingObjects<CredentialEntity>

}
