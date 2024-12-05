import Factory
import Foundation

struct FetchMetadataUseCase: FetchMetadataUseCaseProtocol {

  init(repository: OpenIDRepositoryProtocol = Container.shared.openIDRepository()) {
    self.repository = repository
  }

  private let repository: OpenIDRepositoryProtocol

  func execute(from issuerUrl: URL) async throws -> CredentialMetadata {
    try await repository.fetchMetadata(from: issuerUrl)
  }
}
