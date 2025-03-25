import Factory
import Foundation

// MARK: - GetLoginAttemptCounterUseCase

struct GetLoginAttemptCounterUseCase: GetLoginAttemptCounterUseCaseProtocol {

  func execute(kind: AuthMethod) throws -> Int {
    try repository.getAttempts(kind: kind)
  }

  @Injected(\.loginRepository) private var repository: LoginRepositoryProtocol
}
