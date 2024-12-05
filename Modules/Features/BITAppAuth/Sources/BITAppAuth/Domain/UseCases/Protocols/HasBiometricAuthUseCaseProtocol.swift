import Foundation
import Spyable

@Spyable
public protocol HasBiometricAuthUseCaseProtocol {
  func execute() -> Bool
}
