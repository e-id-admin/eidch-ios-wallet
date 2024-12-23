import Foundation

public protocol BiometricChangeDelegate: AnyObject {
  func didBiometricStatusChange(to isEnabled: Bool)
}
