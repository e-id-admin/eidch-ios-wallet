import Spyable

@Spyable
public protocol GetLoginAttemptCounterUseCaseProtocol {
  func execute(kind: AuthMethod) throws -> Int
}
