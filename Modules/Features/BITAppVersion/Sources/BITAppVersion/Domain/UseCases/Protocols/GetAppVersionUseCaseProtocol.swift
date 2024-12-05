import Foundation
import Spyable

// MARK: - GetAppVersionUseCaseProtocol

@Spyable
public protocol GetAppVersionUseCaseProtocol {
  func execute() throws -> AppVersion
}
