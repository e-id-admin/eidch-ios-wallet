import BITCore
import BITCredentialShared
import BITOpenID
import Factory
import Foundation

// MARK: - VerifierDisplay

public struct VerifierDisplay {

  init(name: String?, logo: Data?, trustStatus: TrustStatus) {
    self.name = name
    self.logo = logo
    self.trustStatus = trustStatus
  }

  // MARK: Internal

  var name: String?
  var logo: Data?
  var trustStatus: TrustStatus

}

// MARK: Equatable

extension VerifierDisplay: Equatable {
  public static func == (lhs: VerifierDisplay, rhs: VerifierDisplay) -> Bool {
    lhs.name == rhs.name && lhs.logo == rhs.logo && lhs.trustStatus == rhs.trustStatus
  }
}

#if DEBUG
extension VerifierDisplay {
  struct Mock {
    static let sample = VerifierDisplay(name: "Verifier", logo: nil, trustStatus: .verified)
  }
}
#endif
