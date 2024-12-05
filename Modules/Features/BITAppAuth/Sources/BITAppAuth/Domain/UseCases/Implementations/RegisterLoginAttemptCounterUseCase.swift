import Factory
import Foundation

// MARK: - RegisterLoginAttemptCounterUseCase

struct RegisterLoginAttemptCounterUseCase: RegisterLoginAttemptCounterUseCaseProtocol {

  let repository: LoginRepositoryProtocol

  init(repository: LoginRepositoryProtocol = Container.shared.loginRepository()) {
    self.repository = repository
  }

  @discardableResult
  func execute(kind: AuthMethod) throws -> Int {
    let value = try repository.getAttempts(kind: kind) + 1
    return try repository.registerAttempt(value, kind: kind)
  }
}
