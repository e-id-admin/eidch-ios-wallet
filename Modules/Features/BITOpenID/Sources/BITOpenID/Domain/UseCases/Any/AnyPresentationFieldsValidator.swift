import BITAnyCredentialFormat
import BITCore
import Factory

// MARK: - AnyPresentationFieldsValidatorError

enum AnyPresentationFieldsValidatorError: Error {
  case jsonPathParsingFailed
}

// MARK: - AnyPresentationFieldsValidator

struct AnyPresentationFieldsValidator: AnyPresentationFieldsValidatorProtocol {
  init(anyPresentationFieldsValidatorDispatcher: [CredentialFormat: AnyPresentationFieldsValidatorProtocol] = Container.shared.anyPresentationFieldsValidatorDispatcher()) {
    dispatcher = anyPresentationFieldsValidatorDispatcher
  }

  func validate(_ anyCredential: AnyCredential, with requestedFields: [Field]) throws -> [CodableValue] {
    guard let credentialFormat = CredentialFormat(rawValue: anyCredential.format), let dispatcherFormat = dispatcher[credentialFormat] else {
      throw CredentialFormatError.formatNotSupported
    }

    return try dispatcherFormat.validate(anyCredential, with: requestedFields)
  }

  private let dispatcher: [CredentialFormat: AnyPresentationFieldsValidatorProtocol]
}
