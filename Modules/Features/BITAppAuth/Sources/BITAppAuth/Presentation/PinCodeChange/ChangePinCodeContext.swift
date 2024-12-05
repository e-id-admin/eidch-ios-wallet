import Foundation

// MARK: - ChangePinCodeContext

public class ChangePinCodeContext {
  var uniquePassphrase: Data?
  var newPinCode: String?

  weak var changePinCodeDelegate: ChangePinCodeDelegate?
  weak var newPinCodeDelegate: NewPinCodeDelegate?
}

// MARK: - ChangePinCodeDelegate

public protocol ChangePinCodeDelegate: AnyObject {
  func didChangePinCode()
}

// MARK: - NewPinCodeDelegate

public protocol NewPinCodeDelegate: AnyObject {
  func didFail()
}
