import BITCore
import BITJWT
import Factory

struct ValidateRequestObjectUseCase: ValidateRequestObjectUseCaseProtocol {

  // MARK: Internal

  func execute(_ requestObject: RequestObject) async -> Bool {
    guard
      hasValidResponse(for: requestObject),
      hasValidClientInformation(for: requestObject),
      hasValidClientId(for: requestObject),
      hasValidInputDescriptors(for: requestObject)
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

  private static let didKey = "did"
  private static let vpTokenKey = "vp_token"
  private static let directPostKey = "direct_post"
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
    guard let regex = try? Regex(Self.regex) else { return false }
    return !requestObject.clientId.matches(of: regex).isEmpty
  }

  private func hasValidInputDescriptors(for requestObject: RequestObject) -> Bool {
    let descriptors = requestObject.presentationDefinition.inputDescriptors
    return descriptors.allSatisfy { descriptor in
      !descriptor.constraints.fields.isEmpty
    }
  }

  private func validateJWTIntegrity(of jwtRequestObject: JWTRequestObject) async -> Bool {
    guard
      jwtRequestObject.jwt.algorithm == JWTAlgorithm.ES256.rawValue,
      let kid = jwtRequestObject.jwt.kid,
      (try? await jwtSignatureValidator.validate(jwtRequestObject.jwt, did: jwtRequestObject.clientId, kid: kid)) ?? false
    else {
      return false
    }

    return true
  }

}
