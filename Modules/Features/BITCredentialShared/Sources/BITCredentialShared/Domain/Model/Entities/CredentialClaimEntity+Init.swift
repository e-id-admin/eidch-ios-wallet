import BITEntities
import Foundation

extension CredentialClaimEntity {

  // MARK: Lifecycle

  public convenience init(claim: CredentialClaim) {
    self.init()
    id = claim.id
    setValues(from: claim)
    displays.append(objectsIn: claim.displays.map { CredentialClaimDisplayEntity(display: $0) })
  }

  // MARK: Internal

  func setValues(from claim: CredentialClaim) {
    key = claim.key
    order = claim.order
    value = claim.value
    valueType = claim.valueType
  }

}
