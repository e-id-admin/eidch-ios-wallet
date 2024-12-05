import BITAnyCredentialFormat
import Factory

// MARK: - FetchAnyCredentialUseCase

struct FetchAnyCredentialUseCase: FetchAnyCredentialUseCaseProtocol {

  init(anyFetchCredentialDispatcher: [CredentialFormat: FetchAnyCredentialUseCaseProtocol] = Container.shared.anyFetchCredentialDispatcher()) {
    dispatcher = anyFetchCredentialDispatcher
  }

  func execute(for context: FetchCredentialContext) async throws -> AnyCredential {
    guard let credentialFormat = CredentialFormat(rawValue: context.format), let dispatcherFormat = dispatcher[credentialFormat] else {
      throw CredentialFormatError.formatNotSupported
    }

    return try await dispatcherFormat.execute(for: context)
  }

  private let dispatcher: [CredentialFormat: FetchAnyCredentialUseCaseProtocol]
}
