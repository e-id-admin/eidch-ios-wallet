import Foundation
import Spyable

@Spyable
public protocol FetchPackagesUseCaseProtocol {
  func execute() throws -> [PackageDependency]
}
