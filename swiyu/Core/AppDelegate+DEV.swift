/**
 This file must not be published and must remain secret within the private organisation.
 */

#if DEV
import BITAppVersion
import BITOpenID
import Factory
import Foundation

extension AppDelegate {

  // MARK: Internal

  func registerEnvironmentValues() {
    Self.registerTrustRegistryMapping()
    Self.registerTrustedDids()
    Self.registerBaseRegistryDomainPattern()
    Self.registerAppVersionEnforcementURL()
  }

  // MARK: Private

  private static func registerTrustRegistryMapping() {
    Container.shared.trustRegistryMapping.register {
      [
        Self.baseRegistryBit: Self.trustRegistrySwiyu,
      ]
    }
  }

  private static func registerTrustedDids() {
    Container.shared.trustedDids.register {
      [trustRegistryDidBit]
    }
  }

  private static func registerBaseRegistryDomainPattern() {
    Container.shared.baseRegistryDomainPattern.register { baseRegistryDomainPattern }
  }

  private static func registerAppVersionEnforcementURL() {
    if let appVersionEnforcementUrl {
      Container.shared.versionEnforcementUrl.register { appVersionEnforcementUrl }
    }
  }
}

extension AppDelegate {
  private static var baseRegistryBit: String {
    "identifier-data-service-d.bit.admin.ch"
  }

  private static var trustRegistrySwiyu: String {
    "trust-reg-d.trust-infra.swiyu.admin.ch"
  }

  private static var trustRegistryDidBit: String {
    "did:tdw:Q21CXTbLJnPY5ULk5q2puXQaUv1tPA57gCZepmwrZi5wxtm13fdFmG6oKeWhrYiW3Lfyur4nxRmZo5CJpYL5h7bsT:identifier-data-service-d.bit.admin.ch:api:v1:did:af7f0c35-c36c-49df-994a-df1ccd363608"
  }

  private static var baseRegistryDomainPattern: String {
    #"^did:tdw:[^:]+:([^:]+\.bit\.admin\.ch):[^:]+"#
  }

  private static var appVersionEnforcementUrl: URL? {
    URL(string: "https://enforcement-service-d.bit.admin.ch/platform/ios")
  }
}
#endif
