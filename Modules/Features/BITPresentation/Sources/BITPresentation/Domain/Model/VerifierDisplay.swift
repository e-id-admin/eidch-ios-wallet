import BITCore
import BITCredentialShared
import BITOpenID
import Factory
import Foundation

// MARK: - VerifierDisplay

public struct VerifierDisplay {

  // MARK: Lifecycle

  init(verifier: Verifier?, trustStatus: TrustStatus) {
    self.trustStatus = trustStatus

    if let clientName = verifier?.clientName {
      name = getVerifierDisplay(clientName)
    }

    if let verifierLogoUri = verifier?.logoUri, let verifierLogo = getVerifierDisplay(verifierLogoUri) {
      logoUri = URL(string: verifierLogo)
    }
  }

  init(name: String, logo: Data?, trustStatus: TrustStatus) {
    self.name = name
    self.logo = logo
    self.trustStatus = trustStatus
  }

  // MARK: Internal

  var name: String?
  var logo: Data?
  var logoUri: URL?
  var trustStatus: TrustStatus

  // MARK: Fileprivate

  fileprivate enum VerifierDisplayAttribute {
    case clientName
    case logo
  }

  // MARK: Private

  @Injected(\.preferredUserLanguageCodes) private var preferredUserLanguageCodes: [UserLanguageCode]

  private func getVerifierDisplay(_ displays: Verifier.LocalizedDisplay) -> String? {
    for languageCode in preferredUserLanguageCodes {
      if let display = displays.value(for: languageCode) {
        return display
      }
    }

    if let display = displays.value(for: UserLanguageCode.defaultAppLanguageCode) {
      return display
    }

    if let display = displays.fallback() {
      return display
    }

    return nil
  }

}

// MARK: Equatable

extension VerifierDisplay: Equatable {
  public static func == (lhs: VerifierDisplay, rhs: VerifierDisplay) -> Bool {
    lhs.name == rhs.name && lhs.logo == rhs.logo && lhs.trustStatus == rhs.trustStatus && lhs.logoUri == rhs.logoUri
  }
}

#if DEBUG
extension VerifierDisplay {
  struct Mock {
    static let sample: VerifierDisplay = .init(name: "Verifier", logo: nil, trustStatus: .verified)
  }
}
#endif
