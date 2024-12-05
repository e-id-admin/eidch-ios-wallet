import BITAnalytics
import BITCore
import Combine
import Factory

// MARK: - PresentationRequestReviewViewModel

/// `important`: The implementation supports and takes only the first input descriptor give by the context
///
/// The supports of multiple input descriptor has to be defined.
@MainActor
public class PresentationRequestReviewViewModel: StateMachine<PresentationRequestReviewViewModel.State, PresentationRequestReviewViewModel.Event> {

  // MARK: Lifecycle

  public init(
    _ initialState: State = .results,
    context: PresentationRequestContext,
    router: PresentationRouterRoutes = Container.shared.presentationRouter())
  {
    self.context = context
    self.router = router

    if
      let inputDescriptorId = context.requestObject.presentationDefinition.inputDescriptors.first?.id,
      let credential = context.selectedCredentials[inputDescriptorId]
    {
      self.credential = credential
      super.init(initialState)
    } else {
      super.init(.invalidCredentialError)
    }

    guard let trustStatement = context.trustStatement else {
      verifierDisplay = .init(verifier: context.requestObject.clientMetadata, trustStatus: .unverified)
      return
    }

    verifierDisplay = getVerifierDisplayUseCase.execute(for: context.requestObject.clientMetadata, trustStatement: trustStatement)
  }

  // MARK: Public

  public enum State: Equatable {
    case results
    case error
    case invalidCredentialError
  }

  public enum Event: AnalyticsEventProtocol {
    case close
    case deny
    case submit
    case onSuccess
    case setError(_ error: Error)

    case retry
    case didDenyPresentation
  }

  override public func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch event {
    case .close,
         .didDenyPresentation:
      router.close()

    case .deny:
      return AnyPublisher.run(withDelay: 0.5) {
        try await self.denyPresentationUseCase.execute(context: self.context, error: .clientRejected)
      } onSuccess: {
        .didDenyPresentation
      } onError: { _ in
        .didDenyPresentation
      }

    case .submit:
      isLoading = true

      return AnyPublisher.run(withDelay: 0.5) {
        try await self.submitPresentationUseCase.execute(context: self.context)
      } onSuccess: {
        .onSuccess
      } onError: { error in
        .setError(error)
      }

    case .onSuccess:
      router.close()

    case .setError(let error):
      isLoading = false
      stateError = error
      analytics.log(error)

      guard let presentationError = error as? SubmitPresentationError, presentationError == .credentialInvalid else {
        state = .error
        return nil
      }

      state = .invalidCredentialError

    case .retry:
      state = .results
      stateError = nil
    }

    return nil
  }

  // MARK: Internal

  @Published var isLoading: Bool = false

  var verifierDisplay: VerifierDisplay?
  var context: PresentationRequestContext
  var credential: CompatibleCredential?

  // MARK: Private

  private let router: PresentationRouterRoutes
  @Injected(\.analytics) private var analytics: AnalyticsProtocol
  @Injected(\.submitPresentationUseCase) private var submitPresentationUseCase: SubmitPresentationUseCaseProtocol
  @Injected(\.denyPresentationUseCase) private var denyPresentationUseCase: DenyPresentationUseCaseProtocol
  @Injected(\.getVerifierDisplayUseCase) private var getVerifierDisplayUseCase: GetVerifierDisplayUseCaseProtocol

}
