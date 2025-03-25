import BITLocalAuthentication
import Factory
import Foundation

// MARK: - HasDevicePinUseCase

public struct HasDevicePinUseCase: HasDevicePinUseCaseProtocol {

  // MARK: Public

  public func execute() -> Bool {
    do {
      return try validator.validatePolicy(.deviceOwnerAuthentication, context: context)
    } catch {
      return false
    }
  }

  // MARK: Private

  @Injected(\.internalContext) private var context: LAContextProtocol
  @Injected(\.localAuthenticationPolicyValidator) private var validator: LocalAuthenticationPolicyValidatorProtocol
}

// MARK: - MockHasDevicePinUseCase

#if DEBUG || targetEnvironment(simulator)
struct MockHasDevicePinUseCase: HasDevicePinUseCaseProtocol {

  init(_ value: Bool = false) {
    self.value = value
  }

  private var value: Bool

  func execute() -> Bool {
    value
  }
}
#endif
