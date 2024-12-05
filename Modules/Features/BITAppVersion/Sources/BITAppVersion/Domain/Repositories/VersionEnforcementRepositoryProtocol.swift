import Foundation
import Spyable

@Spyable
protocol VersionEnforcementRepositoryProtocol {
  func fetchVersionEnforcements() async throws -> [VersionEnforcement]
}
