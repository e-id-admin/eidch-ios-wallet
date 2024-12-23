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

  public var fetchCredentialUseCase: Factory<FetchCredentialUseCaseProtocol> {
    self { FetchCredentialUseCase() }
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
    self { [ self.trustRegistryDid() ] }
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

  #warning("must be defined")
  private var trustRegistryDid: Factory<String> {
    self { "did:tdw:123456" }
  }

}

// MARK: - AnyFetcher

extension Container {

  // MARK: Public

  public var anyDescriptorMapGenerator: Factory<AnyDescriptorMapGeneratorProtocol> {
    self { AnyDescriptorMapGenerator() }
  }

  public var anyPresentationFieldsValidator: Factory<AnyPresentationFieldsValidatorProtocol> {
    self { AnyPresentationFieldsValidator() }
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

  var anyPresentationFieldsValidatorDispatcher: Factory<[CredentialFormat: AnyPresentationFieldsValidatorProtocol]> {
    self {
      [
        CredentialFormat.vcSdJwt: VcSdJwtPresentationFieldsValidator(),
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

  // MARK: Internal

  var trustRegistryRepository: Factory<TrustRegistryRepositoryProtocol> {
    self { TrustRegistryRepository() }
  }

  var validateTrustStatementUseCase: Factory<ValidateTrustStatementUseCaseProtocol> {
    self { ValidateTrustStatementUseCase() }
  }

  var bundleInfoDictionary: Factory<[String: Any]?> {
    self { Bundle.main.infoDictionary }
  }

}
