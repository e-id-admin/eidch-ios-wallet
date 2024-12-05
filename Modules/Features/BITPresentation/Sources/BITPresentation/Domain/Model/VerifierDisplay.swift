import BITCredentialShared
import BITOpenID
import Foundation

// MARK: - VerifierDisplay

public struct VerifierDisplay {

  init(verifier: Verifier?, trustStatus: TrustStatus) {
    logoUri = verifier?.logoUri
    name = verifier?.clientName
    self.trustStatus = trustStatus
  }

  init(name: String, logo: Data?, trustStatus: TrustStatus) {
    self.name = name
    self.logo = logo
    self.trustStatus = trustStatus
  }

  var name: String?
  var logo: Data?
  var logoUri: URL?
  var trustStatus: TrustStatus
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
