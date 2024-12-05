import BITCore
import BITCrypto
import BITEntities
import BITOpenID
import Foundation

// MARK: - CredentialIssuerDisplay

public struct CredentialIssuerDisplay: Codable, Equatable, DisplayLocalizable {

  // MARK: Lifecycle

  public init(id: UUID = .init(), locale: String? = nil, name: String, credentialId: UUID?, image: Data?) {
    self.id = id
    self.locale = locale ?? UserLocale.defaultLocaleIdentifier
    self.name = name
    self.credentialId = credentialId
    self.image = image
  }

  init(_ entity: CredentialIssuerDisplayEntity) {
    self.init(
      id: entity.id,
      locale: entity.locale,
      name: entity.name,
      credentialId: entity.credential.first?.id,
      image: entity.image)
  }

  public init(_ display: CredentialMetadata.CredentialMetadataDisplay, credentialId: UUID) {
    self.init(
      locale: display.locale,
      name: display.name,
      credentialId: credentialId,
      image: display.logo?.uri.flatMap { Data(base64Encoded: $0) })
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(UUID.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    locale = try container.decodeIfPresent(String.self, forKey: .locale) ?? UserLocale.defaultLocaleIdentifier
    credentialId = try container.decodeIfPresent(UUID.self, forKey: .credentialId)
    image = try container.decodeIfPresent(Data.self, forKey: .image)
  }

  // MARK: Public

  public var id: UUID
  public var name: String
  public var locale: UserLocale?
  public var credentialId: UUID?
  public var image: Data?

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case image
    case locale
    case credentialId = "credential_id"
  }
}
