import Foundation
import Spyable

@Spyable
public protocol LoginPinCodeUseCaseProtocol {
  func execute(from pinCode: PinCode) throws
}
