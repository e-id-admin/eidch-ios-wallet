import Foundation
import Spyable

@Spyable
public protocol VersionEnforcementRepositoryProtocol {
  func fetchVersionEnforcements() async throws -> [VersionEnforcement]
}
