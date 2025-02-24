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

    guard let trustStatement = context.trustStatement else {
      verifierDisplay = VerifierDisplay(verifier: context.requestObject.clientMetadata, trustStatus: .unverified)
      return
    }
    verifierDisplay = getVerifierDisplayUseCase.execute(for: context.requestObject.clientMetadata, trustStatement: trustStatement)
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
