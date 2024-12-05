import Foundation
import Spyable

@Spyable
protocol GetCredentialsCountUseCaseProtocol {
  func execute() async throws -> Int
}
