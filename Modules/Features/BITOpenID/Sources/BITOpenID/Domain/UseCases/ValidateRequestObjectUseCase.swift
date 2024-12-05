import BITCore
import BITJWT
import Factory

struct ValidateRequestObjectUseCase: ValidateRequestObjectUseCaseProtocol {

  // MARK: Internal

  func execute(_ requestObject: RequestObject) async -> Bool {
    guard
      hasValidResponse(for: requestObject),
      hasValidClientInformation(for: requestObject),
      hasValidClientId(for: requestObject)
    else {
      return false
    }

    // If it's not a `JWTRequestObject`, we don't do the integrity check
    guard let jwtRequestObject = requestObject as? JWTRequestObject else {
      return true
    }

    return await validateJWTIntegrity(of: jwtRequestObject)
  }

  // MARK: Private

  private static let didKey: String = "did"
  private static let vpTokenKey: String = "vp_token"
  private static let directPostKey: String = "direct_post"
  private static let regex = "^did:[a-z0-9]+:[a-zA-Z0-9.\\-_:]+$"

  @Injected(\.jwtSignatureValidator) private var jwtSignatureValidator: JWTSignatureValidatorProtocol

  private func hasValidResponse(for requestObject: RequestObject) -> Bool {
    requestObject.responseType == Self.vpTokenKey &&
      requestObject.responseMode == Self.directPostKey
  }

  private func hasValidClientInformation(for requestObject: RequestObject) -> Bool {
    requestObject.clientIdScheme == Self.didKey
  }

  private func hasValidClientId(for requestObject: RequestObject) -> Bool {
    RegexHelper.matches(Self.regex, in: requestObject.clientId)
  }

  private func validateJWTIntegrity(of jwtRequestObject: JWTRequestObject) async -> Bool {
    guard
      jwtRequestObject.jwt.algorithm == JWTAlgorithm.ES256.rawValue,
      let kid = jwtRequestObject.jwt.kid,
      let updatedKid = kid.components(separatedBy: "#").first,
      (try? await jwtSignatureValidator.validate(jwtRequestObject.jwt, from: updatedKid)) ?? false
    else {
      return false
    }

    return true
  }

}
