/**
 This file must not be published and must remain secret within the private organisation.
 */

#if ABN
import BITAppVersion
import BITOpenID
import Factory
import Foundation

extension AppDelegate {

  // MARK: Internal

  func registerEnvironmentValues() {
    Self.registerTrustRegistryMapping()
    Self.registerTrustedDids()
    Self.registerAppVersionEnforcementURL()
  }

  // MARK: Private

  private static func registerTrustRegistryMapping() {
    Container.shared.trustRegistryMapping.register {
      [
        Self.baseRegistry: Self.trustRegistry,
        Self.baseRegistryInt: Self.trustRegistryInt,
      ]
    }
  }

  private static func registerTrustedDids() {
    Container.shared.trustedDids.register {
      [trustRegistryDid, trustRegistryDidInt]
    }
  }

  private static func registerAppVersionEnforcementURL() {
    if let appVersionEnforcementUrl {
      Container.shared.versionEnforcementUrl.register { appVersionEnforcementUrl }
    }
  }

}

extension AppDelegate {
  private static var baseRegistry: String {
    "identifier-reg-a.trust-infra.swiyu.admin.ch"
  }

  private static var baseRegistryInt: String {
    "identifier-reg-a.trust-infra.swiyu-int.admin.ch"
  }

  private static var trustRegistry: String {
    "trust-reg-a.trust-infra.swiyu.admin.ch"
  }

  private static var trustRegistryInt: String {
    "trust-reg-a.trust-infra.swiyu-int.admin.ch"
  }

  private static var trustRegistryDid: String {
    "did:tdw:7JtnC1qK4QhcbmfaRPZEEPw5dg54Su28PQi9RTGZ2RYrPJFQStrqsruWJFW9XfSyrdmpriCJZBbMJYFDdgo1N1pPzgBpp:identifier-reg-a.trust-infra.swiyu.admin.ch:api:v1:did:b7d61e33-30de-412f-a0b2-1f17a28a0d1b"
  }

  private static var trustRegistryDidInt: String {
    "did:tdw:8WVPLzckMLgtNgmKhpBanGY634Esh3Rryysh24s8LJVFYFbNSgAQ2A8Rox4pRnedMfqqNW6ZZzkEC9rn7QXwdJrsUbMFp:identifier-reg-a.trust-infra.swiyu-int.admin.ch:api:v1:did:3aff69ee-d1bb-4298-b039-0e8d1a7b9f89"
  }

  private static var appVersionEnforcementUrl: URL? {
    URL(string: "https://wallet-ve-a.trust-infra.swiyu.admin.ch/v1/ios")
  }
}
#endif
