import Foundation
import Spyable

@Spyable
public protocol IsBiometricInvalidatedUseCaseProtocol {
  func execute() -> Bool
}
