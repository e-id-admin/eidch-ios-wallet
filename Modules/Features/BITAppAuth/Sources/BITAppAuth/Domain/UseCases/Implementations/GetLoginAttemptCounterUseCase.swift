import Factory
import Foundation

// MARK: - GetLoginAttemptCounterUseCase

struct GetLoginAttemptCounterUseCase: GetLoginAttemptCounterUseCaseProtocol {

  let repository: LoginRepositoryProtocol

  init(repository: LoginRepositoryProtocol = Container.shared.loginRepository()) {
    self.repository = repository
  }

  func execute(kind: AuthMethod) throws -> Int {
    try repository.getAttempts(kind: kind)
  }
}
