import BITCredentialShared
import BITOpenID
import Spyable

@Spyable
public protocol SubmitPresentationUseCaseProtocol {
  func execute(context: PresentationRequestContext) async throws
}
