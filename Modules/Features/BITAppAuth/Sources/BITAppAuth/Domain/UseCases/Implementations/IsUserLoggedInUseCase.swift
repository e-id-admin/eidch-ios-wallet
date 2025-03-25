import Factory
import Foundation
import Spyable

// MARK: - IsUserLoggedInUseCaseProtocol

@Spyable
public protocol IsUserLoggedInUseCaseProtocol {
  func execute() -> Bool
}

// MARK: - IsUserLoggedInUseCase

public struct IsUserLoggedInUseCase: IsUserLoggedInUseCaseProtocol {
  public func execute() -> Bool {
    userSession.isLoggedIn
  }

  @Injected(\.userSession) private var userSession: Session
}
