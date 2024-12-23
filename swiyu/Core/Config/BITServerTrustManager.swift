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
    case trustInfra
    case trustInfraInt

    // MARK: Internal

    var domain: Domain {
      switch self {
      case .dynatrace: Domain.mamManagedBitAdminCh
      case .versionEnforcement: Domain.enforcementServiceBitAdminCh
      case .trustInfra: Domain.trustInfraSwiyuAdminCh
      case .trustInfraInt: Domain.trustInfraIntSwiyuAdminCh
      }
    }

    var certificate: [Certificate] {
      switch self {
      case .dynatrace: [.dynatraceRoot]
      case .trustInfra,
           .trustInfraInt,
           .versionEnforcement: [.adminChRoot]
      }
    }
  }

  fileprivate enum Domain: String, CaseIterable {
    case mamManagedBitAdminCh
    case enforcementServiceBitAdminCh
    case trustInfraSwiyuAdminCh
    case trustInfraIntSwiyuAdminCh

    // MARK: Internal

    var rawValue: String {
      switch self {
      case .mamManagedBitAdminCh: Self.getMamManagedDomain()
      case .enforcementServiceBitAdminCh: Self.getVersionEnforcementDomain()
      case .trustInfraSwiyuAdminCh: Self.getTrustInfraDomain()
      case .trustInfraIntSwiyuAdminCh: Self.getTrustInfraIntDomain()
      }
    }

    // MARK: Private

    private static func getVersionEnforcementDomain() -> String {
      guard let domain = Container.shared.versionEnforcementUrl().host else {
        fatalError("Unavailable app version enforcement domain")
      }
      return domain
    }

    private static func getMamManagedDomain() -> String {
      Container.shared.mamManagedDomain()
    }

    private static func getTrustInfraDomain() -> String {
      Container.shared.trustInfraWildCardDomain()
    }

    private static func getTrustInfraIntDomain() -> String {
      Container.shared.trustInfraIntWildCardDomain()
    }
  }

  fileprivate enum Certificate: String, CaseIterable {
    case dynatraceRoot = "qvrca2g3"
    case adminChRoot = "dcgrg2"
  }
}
