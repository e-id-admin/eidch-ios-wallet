import Foundation

// MARK: - AuthMethod

public enum AuthMethod: CaseIterable {
  case appPin
  case biometric
}

extension AuthMethod {

  // MARK: Internal

  var accessControlFlags: SecAccessControlCreateFlags {
    switch self {
    case .appPin:
      [.applicationPassword]
    case .biometric:
      [.biometryCurrentSet]
    }
  }

  var identifierKey: String {
    switch self {
    case .appPin: Self.uniquePassphraseAppPinIdentifierKey
    case .biometric: Self.uniquePassphraseBiometricIdentifierKey
    }
  }

  var attemptKey: String {
    switch self {
    case .appPin: Self.loginPinAttemptsKey
    case .biometric: Self.loginBiometricAttemptsKey
    }
  }

  // MARK: Private

  private static let uniquePassphraseAppPinIdentifierKey = "uniquePassphraseAppPinIdentifierKey"
  private static let uniquePassphraseBiometricIdentifierKey = "uniquePassphraseBiometricIdentifierKey"

  private static let loginPinAttemptsKey = "loginPinAttemptsKey"
  private static let loginBiometricAttemptsKey = "loginBiometricAttemptsKey"
}
