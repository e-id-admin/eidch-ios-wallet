import BITAnalytics
import BITCore
import BITCredentialShared
import Combine
import Factory
import Foundation

// MARK: - PresentationRequestResultStateViewModel

@MainActor
public class PresentationRequestResultStateViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    state: PresentationRequestResultState,
    context: PresentationRequestContext,
    router: PresentationRouterRoutes = Container.shared.presentationRouter())
  {
    self.state = state
    self.router = router

    verifierDisplay = getVerifierDisplayUseCase.execute(for: context.requestObject.clientMetadata, trustStatement: context.trustStatement)
  }

  // MARK: Internal

  let state: PresentationRequestResultState
  var verifierDisplay: VerifierDisplay?

  func close() {
    router.close()
  }

  func retry() {
    router.pop()
  }

  // MARK: Private

  private let router: PresentationRouterRoutes
  @Injected(\.getVerifierDisplayUseCase) private var getVerifierDisplayUseCase: GetVerifierDisplayUseCaseProtocol

}
