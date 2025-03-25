import Factory
import Foundation

// MARK: - RegisterLoginAttemptCounterUseCase

struct RegisterLoginAttemptCounterUseCase: RegisterLoginAttemptCounterUseCaseProtocol {

  @discardableResult
  func execute(kind: AuthMethod) throws -> Int {
    let value = try repository.getAttempts(kind: kind) + 1
    return try repository.registerAttempt(value, kind: kind)
  }

  @Injected(\.loginRepository) private var repository: LoginRepositoryProtocol
}
