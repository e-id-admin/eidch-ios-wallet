import Foundation
import Spyable

@Spyable
public protocol CheckInvitationTypeUseCaseProtocol {
  func execute(url: URL) async throws -> InvitationType
}
