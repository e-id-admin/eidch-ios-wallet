import BITLocalAuthentication
import Factory
import Foundation

// MARK: - GetBiometricTypeUseCase

public struct GetBiometricTypeUseCase: GetBiometricTypeUseCaseProtocol {

  // MARK: Public

  public func execute() -> BiometricType {
    do {
      guard try validator.validatePolicy(.deviceOwnerAuthenticationWithBiometrics, context: context) else { return .none }
      switch context.biometryType {
      case .touchID: return .touchID
      case .faceID: return .faceID
      default: return .none
      }
    } catch {
      return .none
    }
  }

  // MARK: Private

  @Injected(\.internalContext) private var context: LAContextProtocol
  @Injected(\.localAuthenticationPolicyValidator) private var validator: LocalAuthenticationPolicyValidatorProtocol

}
