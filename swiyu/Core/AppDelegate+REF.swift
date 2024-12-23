/**
 This file must not be published and must remain secret within the private organisation.
 */

#if REF
import BITAppVersion
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
    "identifier-data-service-r.bit.admin.ch"
  }

  private static var trustRegistrySwiyu: String {
    "trust-reg-r.trust-infra.swiyu.admin.ch"
  }

  private static var trustRegistryDidBit: String {
    "did:tdw:7LESN18YWuevjg4SgbQykQ9QbCnWap99XYb1CmNy97g8XweewbVCZovk7qYbxtQFHQqCGyRdg9SuToj1ZFrL1yMxmzTaq:identifier-data-service-r.bit.admin.ch:api:v1:did:6bc83aae-ae12-4310-b3b0-d8d79ea376a0"
  }

  private static var baseRegistryDomainPattern: String {
    #"^did:tdw:[^:]+:([^:]+\.bit\.admin\.ch):[^:]+"#
  }

  private static var appVersionEnforcementUrl: URL? {
    URL(string: "https://enforcement-service-r.bit.admin.ch/platform/ios")
  }
}
#endif
