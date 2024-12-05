import Foundation
import Spyable

@Spyable
protocol PepperRepositoryProtocol {
  @discardableResult
  func createPepperKey() throws -> SecKey
  func getPepperKey() throws -> SecKey

  func setPepperInitialVector(_ initialVector: Data) throws
  func getPepperInitialVector() throws -> Data
}
