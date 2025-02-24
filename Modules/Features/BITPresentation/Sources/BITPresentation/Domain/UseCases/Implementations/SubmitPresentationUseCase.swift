import BITAnyCredentialFormat
import BITCredential
import BITCredentialShared
import BITCrypto
import BITLocalAuthentication
import BITNetworking
import BITOpenID
import BITVault
import Factory
import Foundation

// MARK: - SubmitPresentationError

enum SubmitPresentationError: Error {
  case wrongSubmissionUrl
  case inputDescriptorsNotFound
}

// MARK: - SubmitPresentationUseCase

public struct SubmitPresentationUseCase: SubmitPresentationUseCaseProtocol {

  // MARK: Public

  /// `important`: The implementation supports and takes only the first input descriptor give by the context
  ///
  /// The supports of multiple input descriptor has to be defined.
  public func execute(context: PresentationRequestContext) async throws {
    #warning("The submit should take in consideration multiple input descriptors in the future. For now it only takes the first one given by the context.")
    guard
      let firstInputDescriptor = context.requestObject.presentationDefinition.inputDescriptors.first,
      let selectedCredential = context.selectedCredentials[firstInputDescriptor.id] else { throw SubmitPresentationError.inputDescriptorsNotFound }
    let presentationRequestBody = try presentationRequestBodyGenerator.generate(for: selectedCredential, requestObject: context.requestObject, inputDescriptor: firstInputDescriptor)

    guard let submissionURL = URL(string: context.requestObject.responseUri) else {
      throw SubmitPresentationError.wrongSubmissionUrl
    }

    try await repository.submitPresentation(from: submissionURL, presentationRequestBody: presentationRequestBody)
  }

  // MARK: Private

  @Injected(\.presentationRepository) private var repository: PresentationRepositoryProtocol
  @Injected(\.presentationRequestBodyGenerator) private var presentationRequestBodyGenerator: PresentationRequestBodyGeneratorProtocol

}
