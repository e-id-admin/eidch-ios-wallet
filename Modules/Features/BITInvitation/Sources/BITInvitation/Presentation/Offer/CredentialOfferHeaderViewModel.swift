import BITCredentialShared
import BITL10n
import BITTheming
import Foundation
import SwiftUI

// MARK: - CredentialOfferHeaderViewModel

public struct CredentialOfferHeaderViewModel {
  var name: String
  var imageData: Data?
  var credentialTrustStatus: TrustStatus

  public init(_ issuer: CredentialIssuerDisplay, credentialTrustStatus: TrustStatus) {
    name = issuer.name
    imageData = issuer.image
    self.credentialTrustStatus = credentialTrustStatus
  }
}
