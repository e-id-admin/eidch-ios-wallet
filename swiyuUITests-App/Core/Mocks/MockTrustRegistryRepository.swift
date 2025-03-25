import BITOpenID
import Foundation

struct MockTrustRegistryRepository: TrustRegistryRepositoryProtocol {

  func getTrustRegistryDomain(for baseRegistryDomain: String) -> String? {
    "https://example.com"
  }

  func getTrustedDids() throws -> [String] {
    ["did:tdw:example"]
  }

}
