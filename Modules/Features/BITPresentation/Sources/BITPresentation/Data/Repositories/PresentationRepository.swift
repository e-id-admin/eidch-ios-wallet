import BITNetworking
import BITOpenID
import Factory
import Foundation
import Moya

struct PresentationRepository: PresentationRepositoryProtocol {
  private let networkService: NetworkService = NetworkContainer.shared.service()

  func submitPresentation(from url: URL, presentationRequestBody: PresentationRequestBody) async throws {
    try await networkService.request(PresentationEndpoint.submission(url: url, presentationBody: presentationRequestBody))
  }

  func submitPresentation(from url: URL, presentationErrorRequestBody: PresentationErrorRequestBody) async throws {
    try await networkService.request(PresentationEndpoint.errorSubmission(url: url, presentationErrorBody: presentationErrorRequestBody))
  }
}
