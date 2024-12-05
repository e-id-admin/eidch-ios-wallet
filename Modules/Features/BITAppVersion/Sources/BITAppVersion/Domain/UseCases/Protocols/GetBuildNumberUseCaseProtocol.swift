import Foundation
import Spyable

// MARK: - GetBuildNumberUseCaseProtocol

@Spyable
public protocol GetBuildNumberUseCaseProtocol {
  func execute() throws -> BuildNumber
}
