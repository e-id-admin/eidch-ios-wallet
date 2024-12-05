import Foundation
import Spyable

@Spyable
protocol SaltRepositoryProtocol {
  func setPinSalt(_ salt: Data) throws
  func getPinSalt() throws -> Data
}
