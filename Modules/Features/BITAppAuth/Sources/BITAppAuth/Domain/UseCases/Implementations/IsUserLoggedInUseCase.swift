import BITLocalAuthentication
import Factory
import Foundation

// MARK: - IsUserLoggedInUseCase

/// This use case contains a direct dependency to the shared LAContext which
/// allows us to define if the user is logged in or not when the LAContext contains a setCredential
public struct IsUserLoggedInUseCase: IsUserLoggedInUseCaseProtocol {

  public func execute() -> Bool {
    context.isCredentialSet(.applicationPassword)
  }

  private var context: LAContextProtocol {
    Container.shared.authContext()
  }

}
