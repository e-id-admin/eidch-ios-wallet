import Foundation
import Spyable

@Spyable
public protocol ValidatePinCodeRuleUseCaseProtocol {
  func execute(_ pinCode: String) throws
}
