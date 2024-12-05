import Foundation
import Spyable

// MARK: - AppVersionRepositoryProtocol

@Spyable
public protocol AppVersionRepositoryProtocol {
  func getVersion() throws -> String
  func getBuildNumber() throws -> Int
}
