import Spyable

@Spyable
public protocol FetchVersionEnforcementUseCaseProtocol {
  func execute(withTimeout: UInt64) async throws -> VersionEnforcement?
}
