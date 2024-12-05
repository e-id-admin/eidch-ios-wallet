import BITAnyCredentialFormat
import BITJWT
import BITSdJWT
import BITVault
import Factory
import Foundation

struct FetchVcSdJwtCredentialUseCase: FetchAnyCredentialUseCaseProtocol {

  // MARK: Lifecycle

  init(
    jwtSignatureValidator: JWTSignatureValidatorProtocol = Container.shared.jwtSignatureValidator(),
    repository: OpenIDRepositoryProtocol = Container.shared.openIDRepository(),
    jwtContextHelper: JWTContextHelperProtocol = Container.shared.jwtContextHelper())
  {
    self.jwtSignatureValidator = jwtSignatureValidator
    self.repository = repository
    self.jwtContextHelper = jwtContextHelper
  }

  // MARK: Internal

  func execute(for context: FetchCredentialContext) async throws -> AnyCredential {
    var proof: CredentialRequestProof? = nil
    if let keyPair = context.keyPair {
      let jwt = try jwtContextHelper.jwt(using: context, keyPair: keyPair, type: ProofType.openID4Vci.rawValue)
      proof = CredentialRequestProof(jwt: jwt.raw)
    }

    let credentialBody = CredentialRequestBody(
      format: context.format,
      proof: proof,
      credentialDefinition: CredentialRequestBodyDefinition(types: context.credentialOffers))

    let credentialResponse = try await repository.fetchCredential(
      from: context.credentialEndpoint,
      credentialRequestBody: credentialBody,
      acccessToken: context.accessToken)

    guard
      let vcSdJwt = try? VcSdJwt(from: credentialResponse.rawCredential),
      try await jwtSignatureValidator.validate(vcSdJwt)
    else {
      throw FetchCredentialError.verificationFailed
    }

    return vcSdJwt
  }

  // MARK: Private

  private let jwtSignatureValidator: JWTSignatureValidatorProtocol
  private let repository: OpenIDRepositoryProtocol
  private let jwtContextHelper: JWTContextHelperProtocol
}
