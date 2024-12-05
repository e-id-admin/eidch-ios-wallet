import Alamofire
import BITNetworking
import Factory
import Foundation

// MARK: - BITServerTrustManager

/// `BITServerTrustManager`: A subclass of `WildcardServerTrustManager` provided by BITNetworking.
/// Designed for handling server trust and configure certificate pinning for the BIT application based on domain name patterns.
class BITServerTrustManager: WildcardServerTrustManager {

  // MARK: Lifecycle

  init() {
    let evaluators = TrustEvaluator.allCases.compactMap { Self.createEvaluator($0) }
    super.init(evaluators: Dictionary(uniqueKeysWithValues: evaluators))
  }

  // MARK: Private

  private static func createEvaluator(_ evaluator: TrustEvaluator) -> (String, ServerTrustEvaluating)? {
    let secCertificates = evaluator.certificate.compactMap { certificateName in
      CertificateLoader.loadDERCertificate(named: certificateName.rawValue, from: .main)
    }

    return (evaluator.domain.rawValue, PinnedCertificatesTrustEvaluator(certificates: secCertificates))
  }
}

// MARK: BITServerTrustManager.TrustEvaluator

extension BITServerTrustManager {
  fileprivate enum TrustEvaluator: CaseIterable {
    case dynatrace
    case versionEnforcement
    case trustRegistry

    // MARK: Internal

    var domain: Domain {
      switch self {
      case .dynatrace: Domain.mamManagedBitAdminCh
      case .versionEnforcement: Domain.enforcementServiceBitAdminCh
      case .trustRegistry: Domain.trustRegistryBitAdminCh
      }
    }

    var certificate: [Certificate] {
      switch self {
      case .dynatrace: [.qvrca2g3]
      case .trustRegistry,
           .versionEnforcement: [.dcgrg2]
      }
    }
  }

  fileprivate enum Domain: String, CaseIterable {
    case mamManagedBitAdminCh
    case enforcementServiceBitAdminCh
    case trustRegistryBitAdminCh

    // MARK: Internal

    var rawValue: String {
      switch self {
      case .mamManagedBitAdminCh: "mam-managed.bit.admin.ch"
      case .enforcementServiceBitAdminCh: Self.getVersionEnforcementDomain()
      case .trustRegistryBitAdminCh: Self.getTrustRegistryDomain()
      }
    }

    // MARK: Private

    private static func getVersionEnforcementDomain() -> String {
      guard let domain = Container.shared.versionEnforcementUrl().host else {
        fatalError("Unavailable app version enforcement domain")
      }
      return domain
    }

    private static func getTrustRegistryDomain() -> String {
      guard let domain = Container.shared.trustRegistryUrl().host else {
        fatalError("Unavailable trust registry URL")
      }
      return domain
    }
  }

  fileprivate enum Certificate: String, CaseIterable {
    case qvrca2g3 // Dynatrace
    case dcgrg2 // Version enforcement
  }
}
