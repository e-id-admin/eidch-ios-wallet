import BITLocalAuthentication
import Factory
import Foundation

public struct HasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol {

  // MARK: Public

  public func execute() -> Bool {
    do {
      return try validator.validatePolicy(.deviceOwnerAuthenticationWithBiometrics, context: context)
    } catch {
      return false
    }
  }

  // MARK: Private

  @Injected(\.internalContext) private var context: LAContextProtocol
  @Injected(\.localAuthenticationPolicyValidator) private var validator: LocalAuthenticationPolicyValidatorProtocol

}
