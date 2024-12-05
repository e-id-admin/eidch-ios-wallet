import Foundation
import Spyable

@Spyable
public protocol ChangeBiometricStatusUseCaseProtocol {
  func execute(with uniquePassphrase: Data) async throws
}
