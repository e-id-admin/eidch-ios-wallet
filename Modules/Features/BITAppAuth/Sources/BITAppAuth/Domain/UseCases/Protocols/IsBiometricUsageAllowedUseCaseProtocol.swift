import Foundation
import Spyable

@Spyable
public protocol IsBiometricUsageAllowedUseCaseProtocol {
  func execute() -> Bool
}
