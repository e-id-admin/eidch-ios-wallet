import Spyable

@Spyable
public protocol RegisterLoginAttemptCounterUseCaseProtocol {
  @discardableResult
  func execute(kind: AuthMethod) throws -> Int
}
