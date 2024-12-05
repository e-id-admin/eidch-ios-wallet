import Foundation

// MARK: - TokenStatusList

/// https://www.ietf.org/archive/id/draft-ietf-oauth-status-list-03.html
public struct TokenStatusList: Decodable, Equatable {
  public let statusList: StatusList

  enum CodingKeys: String, CodingKey {
    case statusList = "status_list"
  }
}

// MARK: TokenStatusList.StatusList

extension TokenStatusList {

  public struct StatusList: Decodable, Equatable {
    public let index: Int
    public let uri: String

    enum CodingKeys: String, CodingKey {
      case index = "idx"
      case uri
    }
  }
}
