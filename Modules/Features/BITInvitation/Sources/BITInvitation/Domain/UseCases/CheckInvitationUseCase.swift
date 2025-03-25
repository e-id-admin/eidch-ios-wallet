import Factory
import Foundation

// MARK: - CheckCameraError

enum CheckCameraError: Error {
  case wrongScheme
}

// MARK: - CheckInvitationTypeUseCase

public struct CheckInvitationTypeUseCase: CheckInvitationTypeUseCaseProtocol {
  public init() {}

  public func execute(url: URL) async throws -> InvitationType {
    guard let scheme = url.scheme else { throw CheckCameraError.wrongScheme }
    return if InvitationType.credentialOffer.schemes.contains(scheme) {
      .credentialOffer
    } else if InvitationType.presentation.schemes.contains(scheme) {
      .presentation
    } else {
      throw CheckCameraError.wrongScheme
    }
  }
}
