import BITCredentialShared
import Foundation
import Spyable

@Spyable
public protocol CheckAndUpdateCredentialStatusUseCaseProtocol {
  func execute(_ credentials: [Credential]) async throws -> [Credential]
  func execute(for credential: Credential) async throws -> Credential
}
