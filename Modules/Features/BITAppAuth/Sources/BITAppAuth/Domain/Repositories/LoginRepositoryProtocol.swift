import Foundation
import Spyable

@Spyable
protocol LoginRepositoryProtocol {
  @discardableResult
  func registerAttempt(_ number: Int, kind: AuthMethod) throws -> Int
  func getAttempts(kind: AuthMethod) throws -> Int
  func resetAttempts(kind: AuthMethod) throws
}
