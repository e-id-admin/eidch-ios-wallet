import Spyable

@Spyable
public protocol TrustRegistryRepositoryProtocol {
  func getTrustRegistryDomain(for baseRegistryDomain: String) -> String?
  func getTrustedDids() throws -> [String]
}
