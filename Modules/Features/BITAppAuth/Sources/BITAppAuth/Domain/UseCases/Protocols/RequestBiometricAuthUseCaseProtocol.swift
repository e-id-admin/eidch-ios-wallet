import BITLocalAuthentication
import Foundation
import Spyable

@Spyable
public protocol RequestBiometricAuthUseCaseProtocol {
  func execute(reason: String, context: LAContextProtocol) async throws
}
