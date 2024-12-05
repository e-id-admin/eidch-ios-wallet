import BITCredentialShared
import Foundation
import Spyable

@Spyable
public protocol GetCredentialListUseCaseProtocol {
  func execute() async throws -> [Credential]
}
