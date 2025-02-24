import BITAnyCredentialFormat
import Factory

// MARK: - AnyCredentialJsonGenerator

struct AnyCredentialJsonGenerator: AnyCredentialJsonGeneratorProtocol {

  // MARK: Internal

  func generate(for anyCredential: AnyCredential) throws -> String {
    guard let credentialFormat = CredentialFormat(rawValue: anyCredential.format), let dispatcherFormat = dispatcher[credentialFormat] else {
      throw CredentialFormatError.formatNotSupported
    }

    return try dispatcherFormat.generate(for: anyCredential)
  }

  // MARK: Private

  @Injected(\.anyCredentialJsonGeneratorDispatcher) private var dispatcher: [CredentialFormat: AnyCredentialJsonGeneratorProtocol]
}
