import Foundation
import Spyable

@Spyable
public protocol LoginBiometricUseCaseProtocol {
  func execute() async throws
}
