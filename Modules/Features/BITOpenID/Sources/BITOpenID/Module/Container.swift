import BITAnyCredentialFormat
import BITCrypto
import BITJWT
import Factory
import Foundation

extension Container {

  // MARK: Public

  public var openIDRepository: Factory<OpenIDRepositoryProtocol> {
    self { OpenIDRepository() }
  }

  public var fetchMetadataUseCase: Factory<FetchMetadataUseCaseProtocol> {
    self { FetchMetadataUseCase() }
  }

  public var fetchAnyVerifiableCredentialUseCase: Factory<FetchAnyVerifiableCredentialUseCaseProtocol> {
    self { FetchAnyVerifiableCredentialUseCase() }
  }

  public var fetchRequestObjectUseCase: Factory<FetchRequestObjectUseCaseProtocol> {
    self { FetchRequestObjectUseCase() }
  }

  public var dateBuffer: Factory<TimeInterval> {
    self { 15 }
  }

  public var validateRequestObjectUseCase: Factory<ValidateRequestObjectUseCaseProtocol> {
    self { ValidateRequestObjectUseCase() }
  }

  public var trustRegistryMapping: Factory<[String: String]> {
    self {
      [
        self.baseRegistryInt(): self.trustRegistryInt(),
        self.baseRegistry(): self.trustRegistry(),
      ]
    }
  }

  public var trustedDids: Factory<[String]> {
    self { [ self.trustRegistryDidIntProd() ] }
  }

  public var presentationFieldsValidator: Factory<PresentationFieldsValidatorProtocol> {
    self { PresentationFieldsValidator() }
  }

  public var typeMetadataService: Factory<TypeMetadataServiceProtocol> {
    self { TypeMetadataService() }
  }

  public var vcSchemaService: Factory<VcSchemaServiceProtocol> {
    self { VcSchemaService() }
  }

  // MARK: Internal

  var credentialKeyPairGenerator: Factory<CredentialKeyPairGeneratorProtocol> {
    self { CredentialKeyPairGenerator() }
  }

  var jwtContextHelper: Factory<JWTContextHelperProtocol> {
    self { JWTContextHelper() }
  }

  var sha256Hasher: Factory<SHA256Hasher> {
    self { SHA256Hasher() }
  }

  var jwtDecoder: Factory<JWTDecoderProtocol> {
    self { JWTDecoder() }
  }

  var preferredKeyBindingAlgorithmsOrdered: Factory<[JWTAlgorithm]> {
    self { [.ES256] }
  }

  var sriValidator: Factory<SRIValidatorProtocol> {
    self { SRIValidator() }
  }

  var jsonSchemaValidator: Factory<JsonSchema> {
    self { JsonSchemaValidator() }
  }

  // MARK: Private

  private var baseRegistryInt: Factory<String> {
    self { "identifier-reg.trust-infra.swiyu-int.admin.ch" }
  }

  private var trustRegistryInt: Factory<String> {
    self { "trust-reg.trust-infra.swiyu-int.admin.ch" }
  }

  private var baseRegistry: Factory<String> {
    self { "identifier-reg.trust-infra.swiyu.admin.ch" }
  }

  private var trustRegistry: Factory<String> {
    self { "trust-reg.trust-infra.swiyu.admin.ch" }
  }

  private var trustRegistryDidIntProd: Factory<String> {
    self { "did:tdw:QmWrXWFEDenvoYWFXxSQGFCa6Pi22Cdsg2r6weGhY2ChiQ:identifier-reg.trust-infra.swiyu-int.admin.ch:api:v1:did:2e246676-209a-4c21-aceb-721f8a90b212" }
  }

}

// MARK: - AnyFetcher

extension Container {

  // MARK: Public

  public var anyDescriptorMapGenerator: Factory<AnyDescriptorMapGeneratorProtocol> {
    self { AnyDescriptorMapGenerator() }
  }

  public var anyVpTokenGenerator: Factory<AnyVpTokenGeneratorProtocol> {
    self { AnyVpTokenGenerator() }
  }

  // MARK: Internal

  var fetchAnyCredentialUseCase: Factory<FetchAnyCredentialUseCaseProtocol> {
    self { FetchAnyCredentialUseCase() }
  }

  var anyDescriptorMapGeneratorDispatcher: Factory<[CredentialFormat: AnyDescriptorMapGeneratorProtocol]> {
    self {
      [
        CredentialFormat.vcSdJwt: VcSdJwtDescriptorMapGenerator(),
      ]
    }
  }

  var anyFetchCredentialDispatcher: Factory<[CredentialFormat: FetchAnyCredentialUseCaseProtocol]> {
    self {
      [
        CredentialFormat.vcSdJwt: FetchVcSdJwtCredentialUseCase(),
      ]
    }
  }

  var anyCredentialJsonGenerator: Factory<AnyCredentialJsonGeneratorProtocol> {
    self { AnyCredentialJsonGenerator() }
  }

  var anyCredentialJsonGeneratorDispatcher: Factory<[CredentialFormat: AnyCredentialJsonGeneratorProtocol]> {
    self {
      [
        CredentialFormat.vcSdJwt: VcSdJwtCredentialJsonGenerator(),
      ]
    }
  }

  var anyVpTokenGeneratorDispatcher: Factory<[CredentialFormat: AnyVpTokenGeneratorProtocol]> {
    self {
      [
        CredentialFormat.vcSdJwt: VcSdJwtVpTokenGenerator(),
      ]
    }
  }
}

// MARK: - VcStatus

extension Container {

  // MARK: Public

  public var statusValidators: Factory<[AnyStatusType: any AnyStatusCheckValidatorProtocol]> {
    self {
      [
        AnyStatusType.tokenStatusList: self.tokenStatusListValidator(),
      ]
    }
  }

  // MARK: Internal

  var tokenStatusListDecoder: Factory<TokenStatusListDecoderProtocol> {
    self { TokenStatusListDecoder() }
  }

  var tokenStatusListByteDecoder: Factory<TokenStatusListByteDecoderProtocol> {
    self { TokenStatusListByteDecoder() }
  }

  var tokenStatusListValidator: Factory<AnyStatusCheckValidatorProtocol> { self { TokenStatusListValidator() } }

}

// MARK: - Trust statement

extension Container {

  // MARK: Public

  public var fetchTrustStatementUseCase: Factory<FetchTrustStatementUseCaseProtocol> {
    self { FetchTrustStatementUseCase() }
  }

  public var baseRegistryDomainPattern: Factory<String> {
    self { #"^did:tdw:[^:]+:([^:]+\.swiyu(-int)?\.admin\.ch):[^:]+"# }
  }

  public var trustRegistryRepository: Factory<TrustRegistryRepositoryProtocol> {
    self { TrustRegistryRepository() }
  }

  // MARK: Internal

  var validateTrustStatementUseCase: Factory<ValidateTrustStatementUseCaseProtocol> {
    self { ValidateTrustStatementUseCase() }
  }

  var constraintPathRegex: Factory<String> {
    self { #".*\[\s*\?.*"# }
  }

}
