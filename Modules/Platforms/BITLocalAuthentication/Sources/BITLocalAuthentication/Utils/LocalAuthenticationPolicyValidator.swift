import Foundation

// MARK: - LocalAuthenticationPolicyError

enum LocalAuthenticationPolicyError: Error {
  case invalidPolicy
}

// MARK: - LocalAuthenticationPolicyValidator

public struct LocalAuthenticationPolicyValidator: LocalAuthenticationPolicyValidatorProtocol {

  public init() {}

  public func validatePolicy(_ policy: LocalAuthenticationPolicy, context: LAContextProtocol) throws {
    var error: NSError?
    guard context.canEvaluatePolicy(policy, error: &error) else {
      throw error ?? LocalAuthenticationPolicyError.invalidPolicy
    }
  }

}
