import BITEntities
import Foundation


enum EIDRequestStateError: Error {
  case invalidState
}


struct EIDRequestState: Decodable {

  // MARK: Lifecycle

  init(id: UUID = UUID(), status: EIDRequestStatus, lastPolledAt: Date = Date()) {
    self.id = id
    state = status.state
    self.lastPolledAt = lastPolledAt
    onlineSessionStartOpenAt = status.queueInformation?.onlineSessionStartOpenAt
    onlineSessionStartTimeoutAt = status.onlineSessionStartCloseAt
  }

  init(id: UUID = UUID(), state: EIDRequestStatus.State, lastPolledAt: Date = Date(), onlineSessionStartOpenAt: Date? = nil, onlineSessionStartTimeoutAt: Date? = nil) {
    self.id = id
    self.state = state
    self.lastPolledAt = lastPolledAt
    self.onlineSessionStartOpenAt = onlineSessionStartOpenAt
    self.onlineSessionStartTimeoutAt = onlineSessionStartTimeoutAt
  }

  init(_ entity: EIDRequestStateEntity) throws {
    guard let state = EIDRequestStatus.State(rawValue: entity.state) else {
      throw EIDRequestStateError.invalidState
    }

    self.init(
      id: entity.id,
      state: state,
      lastPolledAt: entity.lastPolledAt,
      onlineSessionStartOpenAt: entity.onlineSessionStartOpenAt,
      onlineSessionStartTimeoutAt: entity.onlineSessionStartTimeoutAt)
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let rawState = try container.decode(String.self, forKey: .state)

    guard let state = EIDRequestStatus.State(rawValue: rawState) else {
      throw EIDRequestStateError.invalidState
    }

    id = try container.decode(UUID.self, forKey: .id)
    self.state = state
    lastPolledAt = try container.decode(Date.self, forKey: .lastPolledAt)
    onlineSessionStartOpenAt = try container.decodeIfPresent(Date.self, forKey: .onlineSessionStartOpenAt)
    onlineSessionStartTimeoutAt = try container.decodeIfPresent(Date.self, forKey: .onlineSessionStartTimeoutAt)
  }

  // MARK: Internal

  enum CodingKeys: CodingKey {
    case id
    case state
    case lastPolledAt
    case onlineSessionStartOpenAt
    case onlineSessionStartTimeoutAt
  }

  let id: UUID
  let state: EIDRequestStatus.State
  let lastPolledAt: Date
  let onlineSessionStartOpenAt: Date?
  let onlineSessionStartTimeoutAt: Date?
}

// MARK: Equatable

extension EIDRequestState: Equatable {
  static func == (lhs: EIDRequestState, rhs: EIDRequestState) -> Bool {
    lhs.id == rhs.id &&
      lhs.state == rhs.state &&
      lhs.lastPolledAt == rhs.lastPolledAt &&
      lhs.onlineSessionStartOpenAt == rhs.onlineSessionStartOpenAt &&
      lhs.onlineSessionStartTimeoutAt == rhs.onlineSessionStartTimeoutAt
  }
}
