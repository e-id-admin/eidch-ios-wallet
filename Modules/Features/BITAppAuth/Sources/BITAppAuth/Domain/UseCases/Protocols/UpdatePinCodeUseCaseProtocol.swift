import Foundation
import Spyable

@Spyable
public protocol UpdatePinCodeUseCaseProtocol {
  func execute(with newPinCode: PinCode, and uniquePassphrase: Data) throws
}
