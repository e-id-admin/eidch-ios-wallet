import Spyable

@Spyable
protocol TrustRegistryRepositoryProtocol {
  func getTrustRegistryDomain(for baseRegistryDomain: String) -> String?
  func getTrustedDids() throws -> [String]
}
