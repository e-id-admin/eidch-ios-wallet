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
    let scheme = url.scheme

    switch scheme {
    case InvitationType.credentialOffer.scheme: return .credentialOffer
    case InvitationType.presentation.scheme: return .presentation
    default: throw CheckCameraError.wrongScheme
    }
  }
}
