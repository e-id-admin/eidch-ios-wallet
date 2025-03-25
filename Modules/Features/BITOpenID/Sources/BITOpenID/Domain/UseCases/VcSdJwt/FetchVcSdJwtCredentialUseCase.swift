import BITAnyCredentialFormat
import BITJWT
import BITSdJWT
import Factory
import Foundation

struct FetchVcSdJwtCredentialUseCase: FetchAnyCredentialUseCaseProtocol {

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
      let kid = vcSdJwt.kid
    else {
      throw FetchAnyVerifiableCredentialError.validationFailed
    }

    do {
      guard try await jwtSignatureValidator.validate(vcSdJwt, did: vcSdJwt.issuer, kid: kid) else {
        throw FetchAnyVerifiableCredentialError.validationFailed
      }

      guard
        let typeMetadata = try await typeMetadataService.fetch(vcSdJwt),
        let vcSchema = try await vcSchemaService.fetch(for: vcSdJwt, with: typeMetadata),
        vcSchemaService.validate(vcSchema, with: vcSdJwt)
      else {
        return vcSdJwt
      }

      return vcSdJwt
    } catch JWTSignatureValidator.JWTSignatureValidatorError.cannotResolveDid(_) {
      throw FetchAnyVerifiableCredentialError.unknownIssuer
    } catch {
      throw error
    }
  }

  // MARK: Private

  @Injected(\.jwtSignatureValidator) private var jwtSignatureValidator: JWTSignatureValidatorProtocol
  @Injected(\.openIDRepository) private var repository: OpenIDRepositoryProtocol
  @Injected(\.jwtContextHelper) private var jwtContextHelper: JWTContextHelperProtocol
  @Injected(\.vcSchemaService) private var vcSchemaService: VcSchemaServiceProtocol
  @Injected(\.typeMetadataService) private var typeMetadataService: TypeMetadataServiceProtocol

}
