import BITCredential
import BITL10n
import Foundation

extension ActorHeaderView {

  init(verifier: VerifierDisplay) {
    let name = verifier.name ?? L10n.presentationVerifierNameUnknown
    if let imageData = verifier.logo {
      self.init(name: name, trustStatus: verifier.trustStatus, imageData: imageData)
    } else {
      self.init(name: name, trustStatus: verifier.trustStatus)
    }
  }

}
