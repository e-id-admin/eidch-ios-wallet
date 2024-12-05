import BITOpenID
import Factory

@MainActor
extension Container {
  public typealias PresentationCompletionHandler = () -> Void

  public var presentationRequestReviewViewModel: ParameterFactory<(PresentationRequestContext, PresentationRouterRoutes), PresentationRequestReviewViewModel> {
    self {
      PresentationRequestReviewViewModel(context: $0, router: $1)
    }
  }

  public var compatibleCredentialViewModel: ParameterFactory<(context: PresentationRequestContext, inputDescriptorId: String, compatibleCredentials: [CompatibleCredential], router: PresentationRouterRoutes), CompatibleCredentialViewModel> {
    self { CompatibleCredentialViewModel(context: $0, inputDescriptorId: $1, compatibleCredentials: $2, router: $3) }
  }

}

extension Container {

  public var presentationRouter: Factory<PresentationRouter> {
    self { PresentationRouter() }
  }

}

// MARK: - Repository

extension Container {
  public var presentationRepository: Factory<PresentationRepositoryProtocol> {
    self { PresentationRepository() }
  }
}

// MARK: - UseCase

extension Container {

  // MARK: Public

  public var submitPresentationUseCase: Factory<SubmitPresentationUseCaseProtocol> {
    self { SubmitPresentationUseCase() }
  }

  public var denyPresentationUseCase: Factory<DenyPresentationUseCaseProtocol> {
    self { DenyPresentationUseCase() }
  }

  public var getCompatibleCredentialsUseCase: Factory<GetCompatibleCredentialsUseCaseProtocol> {
    self { GetCompatibleCredentialsUseCase() }
  }

  public var presentationRequestBodyGenerator: Factory<PresentationRequestBodyGeneratorProtocol> {
    self { PresentationRequestBodyGenerator() }
  }

  // MARK: Internal

  var getVerifierDisplayUseCase: Factory<GetVerifierDisplayUseCaseProtocol> {
    self { GetVerifierDisplayUseCase() }
  }
}
