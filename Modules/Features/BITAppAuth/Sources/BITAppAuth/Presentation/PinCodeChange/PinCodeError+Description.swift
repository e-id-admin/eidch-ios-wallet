import BITL10n
import Factory
import Foundation

extension PinCodeError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .tooShort: L10n.tkOnboardingPasswordlengthNotification
    case .empty: L10n.tkOnboardingPasswordErrorEmpty
    case .mismatch,
         .wrongPinCode: L10n.tkOnboardingNopasswordmismatchNotification
    }
  }
}
