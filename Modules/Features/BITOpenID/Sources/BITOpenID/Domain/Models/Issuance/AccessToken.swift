import Foundation

// MARK: - AccessToken

public struct AccessToken: Codable, Equatable {
  let cNonce: String?
  let accessToken: String

  enum CodingKeys: String, CodingKey {
    case cNonce = "c_nonce"
    case accessToken = "access_token"
  }
}
