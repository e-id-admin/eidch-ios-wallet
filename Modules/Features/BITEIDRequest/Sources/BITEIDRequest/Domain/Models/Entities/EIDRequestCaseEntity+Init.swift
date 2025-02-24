import BITEntities
import Foundation

extension EIDRequestCaseEntity {

  convenience init(_ eIDRequestCase: EIDRequestCase) {
    self.init()
    id = eIDRequestCase.id
    rawMRZ = eIDRequestCase.rawMRZ

    if let eIDRequestCaseState = eIDRequestCase.state {
      state = EIDRequestStateEntity(eIDRequestCaseState)
    }

    documentNumber = eIDRequestCase.documentNumber
    firstName = eIDRequestCase.firstName
    lastName = eIDRequestCase.lastName
    createdAt = eIDRequestCase.createdAt
  }
}
