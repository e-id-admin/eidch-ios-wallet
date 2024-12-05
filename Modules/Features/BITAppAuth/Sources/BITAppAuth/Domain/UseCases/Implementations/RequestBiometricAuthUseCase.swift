import BITCore
import BITLocalAuthentication
import Factory
import Foundation

public struct RequestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol {

  public func execute(reason: String, context: LAContextProtocol) async throws {
    do {
      NotificationCenter.default.post(name: .permissionAlertPresented, object: nil)
      guard try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) else {
        NotificationCenter.default.post(name: .permissionAlertFinished, object: nil)
        throw AuthError.biometricPolicyEvaluationFailed
      }
      NotificationCenter.default.post(name: .permissionAlertFinished, object: nil)
    } catch {
      NotificationCenter.default.post(name: .permissionAlertFinished, object: nil)
      throw error
    }
  }

}
