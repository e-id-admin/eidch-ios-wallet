import Foundation

// MARK: - PresentationErrorRequestBody

public struct PresentationErrorRequestBody: Codable {

  // MARK: Lifecycle

  public init(error: ErrorType, errorDescription: String? = nil) {
    self.error = error
    self.errorDescription = errorDescription
  }

  // MARK: Public

  public let error: ErrorType

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case error
    case errorDescription = "error_description"
  }

  let errorDescription: String?

}

// MARK: PresentationErrorRequestBody.ErrorType

extension PresentationErrorRequestBody {

  public enum ErrorType: String, Codable {
    case clientRejected = "client_rejected"
    case invalidRequest = "invalid_request"
    case presentationCancelled = "verification_process_closed"
  }
}
