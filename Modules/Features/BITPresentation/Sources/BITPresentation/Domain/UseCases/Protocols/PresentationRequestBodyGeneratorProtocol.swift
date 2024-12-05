import BITCredentialShared
import BITOpenID
import Spyable

@Spyable
public protocol PresentationRequestBodyGeneratorProtocol {
  func generate(for compatibleCredential: CompatibleCredential, requestObject: RequestObject, inputDescriptor: InputDescriptor) throws -> PresentationRequestBody
}
