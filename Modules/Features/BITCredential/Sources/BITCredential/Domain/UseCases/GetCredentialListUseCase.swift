import BITCredentialShared
import Factory
import Foundation

// MARK: - GetCredentialListUseCase

public struct GetCredentialListUseCase: GetCredentialListUseCaseProtocol {

  // MARK: Public

  public func execute() async throws -> [Credential] {
    try await databaseRepository.getAll()
  }

  // MARK: Private

  @Injected(\.databaseCredentialRepository) private var databaseRepository: CredentialRepositoryProtocol
}
