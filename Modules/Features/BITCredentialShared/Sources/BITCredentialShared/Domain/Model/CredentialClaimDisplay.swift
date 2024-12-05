import BITCore
import BITEntities
import BITOpenID
import Foundation

public struct CredentialClaimDisplay: Codable, Hashable, Equatable, DisplayLocalizable {

  // MARK: Lifecycle

  public init(id: UUID = .init(), locale: String? = nil, name: String, claimId: UUID? = nil) {
    self.id = id
    self.locale = locale
    self.name = name
    self.claimId = claimId
  }

  public init(_ entity: CredentialClaimDisplayEntity) {
    self.init(
      id: entity.id,
      locale: entity.locale,
      name: entity.name,
      claimId: entity.claim.first?.id)
  }

  public init(_ claim: CredentialMetadata.ClaimDisplay, claimId: UUID? = nil) {
    self.init(locale: claim.locale, name: claim.name, claimId: claimId)
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(UUID.self, forKey: .id)
    locale = try container.decode(String.self, forKey: .locale)
    name = try container.decode(String.self, forKey: .name)
    claimId = try container.decodeIfPresent(UUID.self, forKey: .claimId)
  }

  // MARK: Public

  public var id: UUID
  public var locale: UserLocale?
  public var name: String
  public var claimId: UUID?

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case id
    case locale
    case name
    case claimId = "claim_id"
  }

}
