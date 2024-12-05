import Foundation
import Spyable

@Spyable
public protocol FetchRequestObjectUseCaseProtocol {
  func execute(_ url: URL) async throws -> RequestObject
}
