import BITOpenID
import Spyable

@Spyable
public protocol DenyPresentationUseCaseProtocol {
  func execute(context: PresentationRequestContext, error: PresentationErrorRequestBody.ErrorType) async throws
}
