import BITAnyCredentialFormat
import Spyable

@Spyable
public protocol PresentationFieldsValidatorProtocol {

  func validate(_ anyCredential: AnyCredential, with requestedFields: [Field]) throws -> [PresentationField]

}
