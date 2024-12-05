import BITL10n
import Factory
import Foundation

extension PinCodeError: LocalizedError {
  public var errorDescription: String? {
    let minimumSize = Container.shared.pinCodeMinimumSize()
    return switch self {
    case .tooShort: L10n.tkOnboardingPasswordErrorTooShort(minimumSize)
    case .empty: L10n.tkOnboardingPasswordErrorEmpty
    case .mismatch,
         .wrongPinCode: L10n.tkOnboardingPasswordErrorMismatch
    }
  }
}
