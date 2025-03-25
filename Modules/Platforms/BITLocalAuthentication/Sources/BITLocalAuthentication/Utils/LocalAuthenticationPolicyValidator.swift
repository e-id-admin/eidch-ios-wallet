import Foundation

// MARK: - LocalAuthenticationPolicyError

enum LocalAuthenticationPolicyError: Error {
  case invalidPolicy
}

// MARK: - LocalAuthenticationPolicyValidator

public struct LocalAuthenticationPolicyValidator: LocalAuthenticationPolicyValidatorProtocol {

  public init() {}

  public func validatePolicy(_ policy: LocalAuthenticationPolicy, context: LAContextProtocol) throws -> Bool {
    var error: NSError?
    let result = context.canEvaluatePolicy(policy, error: &error)
    if let err = error {
      throw err
    }
    return result
  }
}
