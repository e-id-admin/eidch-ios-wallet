import BITCore
import BITNetworking
import Spyable
import XCTest

@testable import BITAnyCredentialFormat
@testable import BITCrypto
@testable import BITOpenID
@testable import BITTestingCore

// MARK: - FetchCredentialUseCaseTests

final class FetchCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyRepository = OpenIDRepositoryProtocolSpy()
    spyDidJWKGenerator = CredentialDidJWKGeneratorProtocolSpy()
    spyKeyPairGenerator = CredentialKeyPairGeneratorProtocolSpy()
    spyFetchAnyCredentialUseCase = FetchAnyCredentialUseCaseProtocolSpy()

    spyKeyPairGenerator.generateIdentifierAlgorithmReturnValue = mockKeyPair
    spyFetchAnyCredentialUseCase.executeForReturnValue = mockAnyCredential
    spyRepository.fetchOpenIdConfigurationFromReturnValue = mockOpenIdConfiguration
    spyRepository.fetchAccessTokenFromPreAuthorizedCodeReturnValue = mockAccessToken
    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockResponse
    spyRepository.fetchIssuerPublicKeyInfoFromReturnValue = mockIssuerPublicKeyInfo

    useCase = FetchCredentialUseCase(
      keyPairGenerator: spyKeyPairGenerator,
      fetchAnyCredentialUseCase: spyFetchAnyCredentialUseCase,
      repository: spyRepository)
  }

  func testFetchCredentialSuccess_withAccessToken() async throws {
    mockAnyCredential.raw = UUID().uuidString
    let credential = try await useCase.execute(
      from: mockUrl,
      metadataWrapper: mockMetadataWrapper,
      credentialOffer: mockCredentialOffer,
      accessToken: mockAccessToken)

    XCTAssertEqual(mockAnyCredential.raw, credential.anyCredential.raw)
    XCTAssertEqual(mockKeyPair.algorithm, credential.keyPair?.algorithm)
    XCTAssertEqual(mockKeyPair.identifier, credential.keyPair?.identifier)
    XCTAssertTrue(spyRepository.fetchOpenIdConfigurationFromCalled)
    XCTAssertFalse(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
    XCTAssertTrue(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
    XCTAssertTrue(spyFetchAnyCredentialUseCase.executeForCalled)
    XCTAssertFalse(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
    XCTAssertFalse(spyRepository.fetchIssuerPublicKeyInfoFromCalled)

    guard let receivedContext = spyFetchAnyCredentialUseCase.executeForReceivedContext else {
      XCTFail("receivedContext must not be nill")
      return
    }
    XCTAssertEqual(mockMetadataWrapper.selectedCredential?.format, receivedContext.format)
    XCTAssertEqual(mockKeyPair.privateKey, receivedContext.keyPair?.privateKey)
    XCTAssertEqual(mockAccessToken, receivedContext.accessToken)
    XCTAssertEqual(mockMetadataWrapper.selectedCredential as? CredentialMetadata.VcSdJwtCredentialConfigurationSupported, receivedContext.selectedCredential as? CredentialMetadata.VcSdJwtCredentialConfigurationSupported)
    XCTAssertEqual(mockMetadataWrapper.credentialMetadata.credentialEndpoint, receivedContext.credentialEndpoint.absoluteString)

  }

  func testFetchCredentialSuccess_withoutProofType() async throws {
    let mockWrapper = CredentialMetadataWrapper.Mock.sampleWithoutProofTypes
    mockAnyCredential.raw = UUID().uuidString
    let credential = try await useCase.execute(
      from: mockUrl,
      metadataWrapper: mockWrapper,
      credentialOffer: mockCredentialOffer,
      accessToken: mockAccessToken)

    XCTAssertEqual(mockAnyCredential.raw, credential.anyCredential.raw)
    XCTAssertNil(credential.keyPair)
    XCTAssertTrue(spyRepository.fetchOpenIdConfigurationFromCalled)
    XCTAssertFalse(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
    XCTAssertFalse(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
    XCTAssertTrue(spyFetchAnyCredentialUseCase.executeForCalled)
    XCTAssertFalse(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
    XCTAssertFalse(spyRepository.fetchIssuerPublicKeyInfoFromCalled)

    guard let receivedContext = spyFetchAnyCredentialUseCase.executeForReceivedContext else {
      XCTFail("receivedContext must not be nill")
      return
    }
    XCTAssertEqual(mockWrapper.selectedCredential?.format, receivedContext.format)
    XCTAssertNil(receivedContext.keyPair)
    XCTAssertEqual(mockAccessToken, receivedContext.accessToken)
    XCTAssertEqual(mockWrapper.selectedCredential as? CredentialMetadata.VcSdJwtCredentialConfigurationSupported, receivedContext.selectedCredential as? CredentialMetadata.VcSdJwtCredentialConfigurationSupported)
    XCTAssertEqual(mockWrapper.credentialMetadata.credentialEndpoint, receivedContext.credentialEndpoint.absoluteString)
  }

  func testFetchCredentialSuccess_withoutAccessToken() async throws {
    mockAnyCredential.raw = UUID().uuidString
    let credential = try await useCase.execute(
      from: mockUrl,
      metadataWrapper: mockMetadataWrapper,
      credentialOffer: mockCredentialOffer,
      accessToken: nil)

    XCTAssertEqual(mockAnyCredential.raw, credential.anyCredential.raw)
    XCTAssertTrue(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
    XCTAssertEqual(mockOpenIdConfiguration.tokenEndpoint, spyRepository.fetchAccessTokenFromPreAuthorizedCodeReceivedArguments?.url)
    XCTAssertTrue(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
    XCTAssertTrue(spyFetchAnyCredentialUseCase.executeForCalled)
    XCTAssertEqual(mockMetadataWrapper.selectedCredential?.format, spyFetchAnyCredentialUseCase.executeForReceivedContext?.format)
    XCTAssertFalse(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
    XCTAssertFalse(spyRepository.fetchIssuerPublicKeyInfoFromCalled)
  }

  func testAccessTokenInvalidGrant() async {
    spyRepository.fetchAccessTokenFromPreAuthorizedCodeThrowableError = NetworkError(status: .invalidGrant)

    do {
      _ = try await useCase.execute(
        from: mockUrl,
        metadataWrapper: mockMetadataWrapper,
        credentialOffer: mockCredentialOffer,
        accessToken: nil)
      XCTFail("An error was expected")
    } catch FetchCredentialError.expiredInvitation {
      XCTAssertTrue(spyRepository.fetchOpenIdConfigurationFromCalled)
      XCTAssertTrue(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
      XCTAssertTrue(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
      XCTAssertFalse(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
      XCTAssertFalse(spyRepository.fetchIssuerPublicKeyInfoFromCalled)
      XCTAssertFalse(spyFetchAnyCredentialUseCase.executeForCalled)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  func testCredentialEnpoindInvalid() async {
    let invalidEndpoint = ""
    let mockMetadataWrapperInvalid: CredentialMetadataWrapper = .init(selectedCredentialSupportedId: "123", credentialMetadata: .init(credentialIssuer: "valid-issuer", credentialEndpoint: invalidEndpoint, credentialConfigurationsSupported: [:], display: []))
    do {
      _ = try await useCase.execute(
        from: mockUrl,
        metadataWrapper: mockMetadataWrapperInvalid,
        credentialOffer: mockCredentialOffer,
        accessToken: nil)
      XCTFail("An error was expected")
    } catch FetchCredentialError.credentialEndpointCreationError {
      XCTAssertFalse(spyRepository.fetchOpenIdConfigurationFromCalled)
      XCTAssertFalse(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
      XCTAssertFalse(spyRepository.fetchIssuerPublicKeyInfoFromCalled)
      XCTAssertFalse(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
      XCTAssertFalse(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
      XCTAssertFalse(spyDidJWKGenerator.generateFromPrivateKeyCalled)
      XCTAssertFalse(spyFetchAnyCredentialUseCase.executeForCalled)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  func testNoFormatAvailable() async {
    let unknownId = "unknown-id"
    let mockMetadataWrapperInvalid: CredentialMetadataWrapper = .init(selectedCredentialSupportedId: unknownId, credentialMetadata: .init(credentialIssuer: "valid-issuer", credentialEndpoint: "some://valid-url", credentialConfigurationsSupported: [:], display: []))
    do {
      _ = try await useCase.execute(
        from: mockUrl,
        metadataWrapper: mockMetadataWrapperInvalid,
        credentialOffer: mockCredentialOffer,
        accessToken: nil)
      XCTFail("An error was expected")
    } catch FetchCredentialError.selectedCredentialNotFound {
      XCTAssertFalse(spyRepository.fetchOpenIdConfigurationFromCalled)
      XCTAssertFalse(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
      XCTAssertFalse(spyRepository.fetchIssuerPublicKeyInfoFromCalled)
      XCTAssertFalse(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
      XCTAssertFalse(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
      XCTAssertFalse(spyDidJWKGenerator.generateFromPrivateKeyCalled)
      XCTAssertFalse(spyFetchAnyCredentialUseCase.executeForCalled)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  // MARK: Private

  private let mockSecKey = SecKeyTestsHelper.createPrivateKey()
  private let mockKeyPair = KeyPair(identifier: UUID(), algorithm: "ES256", privateKey: SecKeyTestsHelper.createPrivateKey())
  private let mockDidJwk = "mockDidJwk"
  private let mockResponse: CredentialResponse = .Mock.sample
  private let mockIssuerPublicKeyInfo: PublicKeyInfo = .Mock.sample
  private let mockAnyCredential = AnyCredentialSpy()
  private let mockOpenIdConfiguration: OpenIdConfiguration = .Mock.sample
  private let mockMetadataWrapper: CredentialMetadataWrapper = .Mock.sample
  private let mockCredentialOffer: CredentialOffer = .Mock.sample
  private let mockAccessToken: AccessToken = .Mock.sample
  // swiftlint:disable all
  private let mockUrl: URL = .init(string: "some://url")!
  // swiftlint:enable all
  private var spyFetchAnyCredentialUseCase = FetchAnyCredentialUseCaseProtocolSpy()
  private var spyDidJWKGenerator = CredentialDidJWKGeneratorProtocolSpy()
  private var spyKeyPairGenerator = CredentialKeyPairGeneratorProtocolSpy()
  private var spyRepository = OpenIDRepositoryProtocolSpy()
  private var useCase = FetchCredentialUseCase()

}
