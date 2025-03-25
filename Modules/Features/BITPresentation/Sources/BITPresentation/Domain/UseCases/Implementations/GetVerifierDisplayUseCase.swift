import BITCore
import BITCredentialShared
import BITOpenID
import Factory
import Foundation

/// Get `VerifierDisplay` from `Verifier` and `TrustStatement` if present
/// If we cannot decode the `TrustStatement`, return the localized verifier display from the verifier's client metadata
///
/// Note: Verifier's `logo` is always taken from the verifier's client metadata, the trust statement is considered only for the `name`
struct GetVerifierDisplayUseCase: GetVerifierDisplayUseCaseProtocol {

  // MARK: Internal

  func execute(for verifier: Verifier?, trustStatement: TrustStatement?) -> VerifierDisplay? {
    let trustStatus: TrustStatus = trustStatement != nil ? .verified : .unverified
    let logo = getVerifierLogo(from: verifier)
    var name = getVerifierName(from: verifier)
    if
      let trustStatement,
      let orgName = try? trustStatement.disclosableClaims.first(where: { $0.key == Self.orgNameKey })?.anyValue() as? [String: Any],
      let trustedName = getDisplayForClaim(orgName, with: Self.orgNameKey, in: trustStatement)
    {
      name = trustedName
    }
    return VerifierDisplay(name: name, logo: logo, trustStatus: trustStatus)
  }

  // MARK: Private

  private static let orgNameKey = "orgName"
  private static let logoUriKey = "logoUri"
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

  private func getVerifierName(from verifier: Verifier?) -> String? {
    Verifier.LocalizedDisplay.getPreferredDisplay(from: verifier?.clientName, considering: preferredUserLanguageCodes)
  }

  private func getVerifierLogo(from verifier: Verifier?) -> Data? {
    guard
      let logoUri = Verifier.LocalizedDisplay.getPreferredDisplay(from: verifier?.logoUri, considering: preferredUserLanguageCodes),
      let decodedURI = CredentialDisplayLogoURIDecoder.decode(logoUri) else
    {
      return nil
    }
    return Data(base64Encoded: decodedURI)
  }
}
