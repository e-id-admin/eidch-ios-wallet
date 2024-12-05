import Factory
import Foundation

// MARK: - ResetLoginAttemptCounterUseCase

public struct ResetLoginAttemptCounterUseCase: ResetLoginAttemptCounterUseCaseProtocol {

  let repository: LoginRepositoryProtocol

  init(repository: LoginRepositoryProtocol = Container.shared.loginRepository()) {
    self.repository = repository
  }

  public func execute() throws {
    for kind in AuthMethod.allCases {
      try repository.resetAttempts(kind: kind)
    }
  }

  public func execute(kind: AuthMethod) throws {
    try repository.resetAttempts(kind: kind)
  }
}
