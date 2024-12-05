import Factory
import Foundation

// MARK: - CompatibleCredentialViewModel

public class CompatibleCredentialViewModel: ObservableObject {

  // MARK: Lifecycle

  public init(
    context: PresentationRequestContext,
    inputDescriptorId: String,
    compatibleCredentials: [CompatibleCredential],
    router: PresentationRouterRoutes)
  {
    self.context = context
    self.inputDescriptorId = inputDescriptorId
    self.compatibleCredentials = compatibleCredentials
    self.router = router

    verifierDisplay = getVerifierDisplayUseCase.execute(for: context.requestObject.clientMetadata, trustStatement: context.trustStatement)
  }

  // MARK: Internal

  @Published var compatibleCredentials: [CompatibleCredential]

  var verifierDisplay: VerifierDisplay? = nil

  func didSelect(credential: CompatibleCredential) {
    context.selectedCredentials[inputDescriptorId] = credential
    router.presentationReview(with: context)
  }

  // MARK: Private

  private var inputDescriptorId: String
  private var context: PresentationRequestContext
  private var router: PresentationRouterRoutes
  @Injected(\.getVerifierDisplayUseCase) private var getVerifierDisplayUseCase: GetVerifierDisplayUseCaseProtocol

}
