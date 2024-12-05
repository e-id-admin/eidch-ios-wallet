import Foundation

// MARK: - PresentationErrorRequestBody

public struct PresentationErrorRequestBody: Codable {

  // MARK: Lifecycle

  public init(error: ErrorType, errorDescription: String? = nil) {
    self.error = error
    self.errorDescription = errorDescription
  }

  // MARK: Public

  public func asDictionnary() -> [String: Any] {
    do {
      let jsonData = try JSONEncoder().encode(self)

      if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
        return dictionary
      }
    } catch { }

    return [:]
  }

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case error
    case errorDescription = "error_description"
  }

  let error: ErrorType
  let errorDescription: String?

}

// MARK: PresentationErrorRequestBody.ErrorType

extension PresentationErrorRequestBody {

  public enum ErrorType: String, Codable {
    case clientRejected = "client_rejected"
    case invalidRequest = "invalid_request"
  }
}
