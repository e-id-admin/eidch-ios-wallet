import BITLocalAuthentication
import Foundation
import Spyable

@Spyable
public protocol RegisterPinCodeUseCaseProtocol {
  func execute(pinCode: PinCode) throws
}
