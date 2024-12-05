import BITCredentialShared
import Foundation
import Spyable

@Spyable
public protocol DeleteCredentialUseCaseProtocol {
  func execute(_ credential: Credential) async throws
}
