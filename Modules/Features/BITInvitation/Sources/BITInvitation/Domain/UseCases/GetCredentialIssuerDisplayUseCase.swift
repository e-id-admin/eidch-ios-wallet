import BITCore
import BITCredentialShared
import BITOpenID
import Factory
import Foundation

/// Get `CredentialIssuerDisplay` from `Credential` and `TrustStatement` if present
/// If cannot decode the `TrustStatement`, return credential's `preferredIssuerDisplay`
///
/// Note: Issuer's `image` is always taken from the credential,the trust statement is considered only for the `name`
struct GetCredentialIssuerDisplayUseCase: GetCredentialIssuerDisplayUseCaseProtocol {

  // MARK: Internal

  func execute(for credential: Credential, trustStatement: TrustStatement) -> CredentialIssuerDisplay? {
    let preferredImage = credential.preferredIssuerDisplay?.image
    guard
      let orgName = try? trustStatement.disclosableClaims.first(where: { $0.key == Self.orgNameKey })?.anyValue() as? [String: Any],
      let name = getDisplayForClaim(orgName, with: Self.orgNameKey, in: trustStatement)
    else {
      return credential.preferredIssuerDisplay
    }

    return CredentialIssuerDisplay(name: name, credentialId: credential.id, image: preferredImage)
  }

  // MARK: Private

  private static let orgNameKey = "orgName"
  private static let prefLangKey = "prefLang"

  @Injected(\.preferredUserLanguageCodes) private var preferredUserLanguageCodes: [UserLanguageCode]

  private func getDisplayForClaim(_ claim: [String: Any], with key: String, in trustStatement: TrustStatement) -> String? {
    for preferredLanguageCode in preferredUserLanguageCodes {
      if let entry = claim.first(where: { $0.key.starts(with: "\(preferredLanguageCode)-") }) {
        return (entry.value as? CodableValue)?.rawValue
      }
    }

    if let entry = claim.first(where: { $0.key.starts(with: UserLanguageCode.defaultAppLanguageCode) }) {
      return (entry.value as? CodableValue)?.rawValue
    }

    guard
      let prefLang = trustStatement.disclosableClaims.first(where: { $0.key == Self.prefLangKey })?.value?.rawValue,
      let entry = claim.first(where: { $0.key.starts(with: prefLang) })
    else {
      return key
    }

    return (entry.value as? CodableValue)?.rawValue
  }

}
