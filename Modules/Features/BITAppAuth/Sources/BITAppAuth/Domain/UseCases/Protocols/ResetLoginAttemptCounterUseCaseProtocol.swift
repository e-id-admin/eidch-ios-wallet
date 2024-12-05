import Spyable

@Spyable
public protocol ResetLoginAttemptCounterUseCaseProtocol {
  func execute() throws
  func execute(kind: AuthMethod) throws
}
