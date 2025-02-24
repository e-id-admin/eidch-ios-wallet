import BITEntities
import Foundation


enum EIDRequestCaseError: Error {
  case invalidState
}


struct EIDRequestCase: Decodable {

  // MARK: Lifecycle

  init(id: String, createdAt: Date = Date(), rawMRZ: [String], documentNumber: String, lastName: String, firstName: String, state: EIDRequestState? = nil) {
    self.id = id
    self.createdAt = createdAt
    self.rawMRZ = rawMRZ.joined(separator: Self.mrzSeparator)
    self.documentNumber = documentNumber
    self.lastName = lastName
    self.firstName = firstName
    self.state = state
  }

  init(_ entity: EIDRequestCaseEntity) throws {
    let mrz = entity.rawMRZ.split(separator: Self.mrzSeparator).map(String.init)

    guard let stateEntity = entity.state else {
      throw EIDRequestCaseError.invalidState
    }

    try self.init(
      id: entity.id,
      createdAt: entity.createdAt,
      rawMRZ: mrz,
      documentNumber: entity.documentNumber,
      lastName: entity.lastName,
      firstName: entity.firstName,
      state: EIDRequestState(stateEntity))
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    rawMRZ = try container.decode(String.self, forKey: .rawMRZ)
    documentNumber = try container.decode(String.self, forKey: .documentNumber)
    lastName = try container.decode(String.self, forKey: .lastName)
    firstName = try container.decode(String.self, forKey: .firstName)
    createdAt = try container.decode(Date.self, forKey: .createdAt)
    state = try container.decodeIfPresent(EIDRequestState.self, forKey: .state)
  }

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case id = "caseId"
    case rawMRZ
    case documentNumber
    case lastName
    case firstName
    case createdAt
    case state
  }

  let id: String
  let rawMRZ: String
  let documentNumber: String
  let lastName: String
  let firstName: String
  let createdAt: Date
  var state: EIDRequestState?

  // MARK: Private

  private static let mrzSeparator = ";"

}

// MARK: Equatable

extension EIDRequestCase: Equatable {
  static func == (lhs: EIDRequestCase, rhs: EIDRequestCase) -> Bool {
    lhs.id == rhs.id &&
      lhs.rawMRZ == rhs.rawMRZ &&
      lhs.lastName == rhs.lastName &&
      lhs.state == rhs.state &&
      lhs.documentNumber == rhs.documentNumber &&
      lhs.createdAt == rhs.createdAt &&
      lhs.firstName == rhs.firstName
  }
}
