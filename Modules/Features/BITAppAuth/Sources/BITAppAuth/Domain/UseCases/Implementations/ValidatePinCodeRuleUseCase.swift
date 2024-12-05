import BITL10n
import Factory
import Foundation

// MARK: - ValidatePinCodeRuleUseCase

struct ValidatePinCodeRuleUseCase: ValidatePinCodeRuleUseCaseProtocol {

  @Injected(\.pinCodeMinimumSize) private var pinCodeMinimumSize: Int

  func execute(_ pinCode: String) throws {
    let pinCode = pinCode.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !pinCode.isEmpty else { throw PinCodeError.empty }
    guard pinCode.count >= pinCodeMinimumSize else { throw PinCodeError.tooShort }
  }

}

// MARK: - PinCodeError

public enum PinCodeError {
  case tooShort
  case empty
  case mismatch
  case wrongPinCode
}
