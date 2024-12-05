import Foundation
import Spyable

@Spyable
public protocol AllowBiometricUsageUseCaseProtocol {
  func execute(allow: Bool) throws
}
