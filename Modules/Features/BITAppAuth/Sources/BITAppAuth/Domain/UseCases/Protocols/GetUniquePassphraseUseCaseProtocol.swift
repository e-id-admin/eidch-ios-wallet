import Foundation
import Spyable

@Spyable
public protocol GetUniquePassphraseUseCaseProtocol {
  @discardableResult
  func execute(from pinCode: PinCode) throws -> Data
}
