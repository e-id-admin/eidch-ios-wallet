import BITCredential
import Factory
import Foundation

struct GetCredentialsCountUseCase: GetCredentialsCountUseCaseProtocol {

  init(repository: CredentialRepositoryProtocol = Container.shared.databaseCredentialRepository()) {
    self.repository = repository
  }

  /// We async/await the call event though repository.count() is synchronous to avoid DB access crashes
  func execute() async throws -> Int {
    try await repository.count()
  }

  private let repository: CredentialRepositoryProtocol
}
