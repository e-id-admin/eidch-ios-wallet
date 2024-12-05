import Foundation
import Spyable

@Spyable
public protocol GetBiometricTypeUseCaseProtocol {
  func execute() -> BiometricType
}
