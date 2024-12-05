import Foundation
import Spyable

@Spyable
public protocol BiometricRepositoryProtocol {
  func allowBiometricUsage(_ allow: Bool) throws
  func isBiometricUsageAllowed() throws -> Bool
}
