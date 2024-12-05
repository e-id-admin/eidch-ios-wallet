import Foundation
import Spyable

@Spyable
public protocol SaltServiceProtocol {
  @discardableResult
  func generateSalt() throws -> Data
}
