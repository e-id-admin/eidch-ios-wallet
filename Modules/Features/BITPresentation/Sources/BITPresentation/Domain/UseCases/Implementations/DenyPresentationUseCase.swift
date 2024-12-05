import BITOpenID
import Factory
import Foundation

struct DenyPresentationUseCase: DenyPresentationUseCaseProtocol {

  func execute(context: PresentationRequestContext, error: PresentationErrorRequestBody.ErrorType) async throws {
    guard let url = URL(string: context.requestObject.responseUri) else {
      throw SubmitPresentationError.wrongSubmissionUrl
    }

    let presentationErrorRequestBody = PresentationErrorRequestBody(error: error)
    try await repository.submitPresentation(from: url, presentationErrorRequestBody: presentationErrorRequestBody)
  }

  @Injected(\.presentationRepository) private var repository: PresentationRepositoryProtocol
}
