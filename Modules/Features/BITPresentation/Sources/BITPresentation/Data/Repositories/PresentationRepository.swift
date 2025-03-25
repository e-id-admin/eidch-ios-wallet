import BITNetworking
import BITOpenID
import Factory
import Foundation
import Moya

// MARK: - PresentationError

enum PresentationError: Error {
  case presentationFailed
  case processClosed
  case invalidCredential
}

// MARK: - PresentationRepository

struct PresentationRepository: PresentationRepositoryProtocol {

  // MARK: Internal

  func submitPresentation(from url: URL, presentationRequestBody: PresentationRequestBody) async throws {
    do {
      try await networkService.request(PresentationEndpoint.submission(url: url, presentationBody: presentationRequestBody))
    } catch {
      try handleError(error)
    }
  }

  func submitPresentation(from url: URL, presentationErrorRequestBody: PresentationErrorRequestBody) async throws {
    try await networkService.request(PresentationEndpoint.errorSubmission(url: url, presentationErrorBody: presentationErrorRequestBody))
  }

  // MARK: Private

  @Injected(\NetworkContainer.service) private var networkService: NetworkService
  @Injected(\NetworkContainer.decoder) private var decoder: JSONDecoder

  private func handleError(_ error: Error) throws {
    guard let err = error as? NetworkError else { throw error }
    switch err.status {
    case .internalServerError,
         .unprocessableEntity:
      throw PresentationError.presentationFailed
    case .badRequest:
      try handleBadRequest(err)
    case .invalidGrant:
      throw PresentationError.invalidCredential
    default: throw error
    }
  }

  private func handleBadRequest(_ error: NetworkError) throws {
    guard
      let errorData = error.response?.data,
      let errorBody = try? decoder.decode(PresentationErrorRequestBody.self, from: errorData)
    else { throw PresentationError.presentationFailed }

    switch errorBody.error {
    case .presentationProcessClosed:
      throw PresentationError.processClosed
    case .invalidRequest:
      throw PresentationError.presentationFailed
    case .invalidCredential:
      throw PresentationError.invalidCredential
    default: throw PresentationError.presentationFailed
    }
  }
}
