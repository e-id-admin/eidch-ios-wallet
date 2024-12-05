import Foundation
import Spyable

@Spyable
public protocol LocalAuthenticationPolicyValidatorProtocol {
  func validatePolicy(_ policy: LocalAuthenticationPolicy, context: LAContextProtocol) throws
}
