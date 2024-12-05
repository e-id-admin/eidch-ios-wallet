import Foundation

enum AuthError: Error {

  case invalidPinData
  case LAContextError(reason: String)
  case missingUniquePassphrase

  case biometricPolicyEvaluationFailed
  case biometricNotAvailable
  case biometricNotAllowed

}
