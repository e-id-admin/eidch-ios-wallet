import BITLocalAuthentication
import Factory
import Foundation

// MARK: - GetBiometricTypeUseCase

public struct GetBiometricTypeUseCase: GetBiometricTypeUseCaseProtocol {

  // MARK: Lifecycle

  init(
    validator: LocalAuthenticationPolicyValidatorProtocol = Container.shared.localAuthenticationPolicyValidator(),
    context: LAContextProtocol = Container.shared.authContext())
  {
    self.context = context
    self.validator = validator
  }

  // MARK: Public

  public func execute() -> BiometricType {
    do {
      try validator.validatePolicy(.deviceOwnerAuthenticationWithBiometrics, context: context)
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

  private var context: LAContextProtocol
  private var validator: LocalAuthenticationPolicyValidatorProtocol

}
