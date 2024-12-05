import Foundation
import Spyable

@Spyable
public protocol PepperServiceProtocol {
  @discardableResult
  func generatePepper() throws -> SecKey
}
