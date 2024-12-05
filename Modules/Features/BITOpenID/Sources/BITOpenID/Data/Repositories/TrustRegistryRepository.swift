import Factory
import Foundation

struct TrustRegistryRepository: TrustRegistryRepositoryProtocol {

  // MARK: Internal

  func getTrustRegistryDomain(for baseRegistryDomain: String) -> String? {
    trustRegistryMapping[baseRegistryDomain]
  }

  func getTrustedDids() -> [String] {
    trustedDids
  }

  // MARK: Private

  @Injected(\.trustRegistryMapping) private var trustRegistryMapping: [String: String]
  @Injected(\.trustedDids) private var trustedDids: [String]
}
