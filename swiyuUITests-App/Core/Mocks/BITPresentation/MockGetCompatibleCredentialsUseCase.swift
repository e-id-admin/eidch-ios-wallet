import BITOpenID
import BITPresentation

struct MockGetCompatibleCredentialsUseCase: GetCompatibleCredentialsUseCaseProtocol {
  func execute(using requestObject: RequestObject) async throws -> [InputDescriptorID: [CompatibleCredential]] {
    let context = PresentationRequestContext.Mock.vcSdJwtSample

    // swiftlint: disable all
    return [context.requestObject.presentationDefinition.inputDescriptors.first!.id: [.Mock.BIT]]
    // swiftlint: enable all
  }
}
