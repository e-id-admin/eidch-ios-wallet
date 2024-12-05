import Foundation
import Spyable

@Spyable
public protocol PinCodeManagerProtocol {
  func encrypt(_ pinCode: PinCode) throws -> Data
}
