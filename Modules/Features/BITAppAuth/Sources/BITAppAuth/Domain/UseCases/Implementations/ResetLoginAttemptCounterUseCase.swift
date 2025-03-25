import Factory
import Foundation

// MARK: - ResetLoginAttemptCounterUseCase

public struct ResetLoginAttemptCounterUseCase: ResetLoginAttemptCounterUseCaseProtocol {

  public func execute() throws {
    for kind in AuthMethod.allCases {
      try repository.resetAttempts(kind: kind)
    }
  }

  public func execute(kind: AuthMethod) throws {
    try repository.resetAttempts(kind: kind)
  }

  @Injected(\.loginRepository) private var repository: LoginRepositoryProtocol
}
