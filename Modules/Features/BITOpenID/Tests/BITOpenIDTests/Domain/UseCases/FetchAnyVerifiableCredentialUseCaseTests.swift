import BITNetworking
import Factory
import XCTest
@testable import BITAnalytics
@testable import BITAnalyticsMocks
@testable import BITAnyCredentialFormat
@testable import BITCrypto
@testable import BITJWT
@testable import BITOpenID
@testable import BITTestingCore

// MARK: - FetchAnyVerifiableCredentialUseCaseTests

final class FetchAnyVerifiableCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = OpenIDRepositoryProtocolSpy()
    didJWKGenerator = CredentialDidJWKGeneratorProtocolSpy()
    keyPairGenerator = CredentialKeyPairGeneratorProtocolSpy()
    fetchAnyCredentialUseCase = FetchAnyCredentialUseCaseProtocolSpy()
    fetchMetadataUseCase = FetchMetadataUseCaseProtocolSpy()

    keyPairGenerator.generateIdentifierAlgorithmReturnValue = mockKeyPair
    fetchAnyCredentialUseCase.executeForReturnValue = mockAnyCredential
    repository.fetchOpenIdConfigurationFromReturnValue = mockOpenIdConfiguration
    repository.fetchAccessTokenFromPreAuthorizedCodeReturnValue = mockAccessToken
    repository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockResponse
    repository.fetchIssuerPublicKeyInfoFromReturnValue = mockIssuerPublicKeyInfo
    fetchMetadataUseCase.executeFromReturnValue = mockMetadata

    analyticsProvider = MockProvider()
    analytics = Analytics()
    analytics.register(analyticsProvider)

    Container.shared.analytics.register { self.analytics }
    Container.shared.credentialKeyPairGenerator.register { self.keyPairGenerator }
    Container.shared.fetchAnyCredentialUseCase.register { self.fetchAnyCredentialUseCase }
    Container.shared.openIDRepository.register { self.repository }
    Container.shared.fetchMetadataUseCase.register { self.fetchMetadataUseCase }
    Container.shared.preferredKeyBindingAlgorithmsOrdered.register { self.mockpreferredKeyBindingAlgorithmsOrdered }

    useCase = FetchAnyVerifiableCredentialUseCase()
  }

  func testFetchCredentialSuccess_withAccessToken() async throws {
    mockAnyCredential.raw = UUID().uuidString
    let (metadataWrapper, credential, keyPair) = try await useCase.execute(from: mockCredentialOffer)

    XCTAssertEqual(mockAnyCredential.raw, credential.raw)
    XCTAssertEqual(mockKeyPair.algorithm, keyPair?.algorithm)
    XCTAssertEqual(mockKeyPair.identifier, keyPair?.identifier)
    XCTAssertTrue(repository.fetchOpenIdConfigurationFromCalled)
    XCTAssertTrue(repository.fetchAccessTokenFromPreAuthorizedCodeCalled)
    XCTAssertTrue(keyPairGenerator.generateIdentifierAlgorithmCalled)
    XCTAssertTrue(fetchAnyCredentialUseCase.executeForCalled)
    XCTAssertFalse(repository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
    XCTAssertFalse(repository.fetchIssuerPublicKeyInfoFromCalled)

    guard let receivedContext = fetchAnyCredentialUseCase.executeForReceivedContext else {
      XCTFail("receivedContext must not be nil")
      return
    }

    XCTAssertEqual(mockMetadataWrapper.selectedCredential?.format, receivedContext.format)
    XCTAssertEqual(mockKeyPair.privateKey, receivedContext.keyPair?.privateKey)
    XCTAssertEqual(mockAccessToken, receivedContext.accessToken)
    XCTAssertEqual(mockMetadataWrapper.selectedCredential as? CredentialMetadata.VcSdJwtCredentialConfigurationSupported, receivedContext.selectedCredential as? CredentialMetadata.VcSdJwtCredentialConfigurationSupported)
    XCTAssertEqual(mockMetadataWrapper.credentialMetadata.credentialEndpoint, receivedContext.credentialEndpoint.absoluteString)

    XCTAssertEqual(analyticsProvider.logCounter, 0)
  }

  func testFetchCredentialSuccess_withoutProofType() async throws {
    fetchMetadataUseCase.executeFromReturnValue = CredentialMetadata.Mock.sampleWithoutProofTypes
    mockAnyCredential.raw = UUID().uuidString
    let (metadataWrapper, credential, keyPair) = try await useCase.execute(from: mockCredentialOffer)

    XCTAssertEqual(mockAnyCredential.raw, credential.raw)
    XCTAssertTrue(repository.fetchOpenIdConfigurationFromCalled)
    XCTAssertTrue(repository.fetchAccessTokenFromPreAuthorizedCodeCalled)
    XCTAssertFalse(keyPairGenerator.generateIdentifierAlgorithmCalled)
    XCTAssertTrue(fetchAnyCredentialUseCase.executeForCalled)
    XCTAssertFalse(repository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
    XCTAssertFalse(repository.fetchIssuerPublicKeyInfoFromCalled)

    guard let receivedContext = fetchAnyCredentialUseCase.executeForReceivedContext else {
      XCTFail("receivedContext must not be nill")
      return
    }
    XCTAssertEqual(metadataWrapper.selectedCredential?.format, receivedContext.format)
    XCTAssertNil(receivedContext.keyPair)
    XCTAssertEqual(mockAccessToken, receivedContext.accessToken)
    XCTAssertEqual(metadataWrapper.selectedCredential as? CredentialMetadata.VcSdJwtCredentialConfigurationSupported, receivedContext.selectedCredential as? CredentialMetadata.VcSdJwtCredentialConfigurationSupported)
    XCTAssertEqual(metadataWrapper.credentialMetadata.credentialEndpoint, receivedContext.credentialEndpoint.absoluteString)

    XCTAssertEqual(analyticsProvider.logCounter, 0)
  }

  func testFetchCredentialSuccess_withoutAccessToken() async throws {
    mockAnyCredential.raw = UUID().uuidString
    let (metadataWrapper, credential, keyPair) = try await useCase.execute(from: mockCredentialOffer)

    XCTAssertEqual(mockAnyCredential.raw, credential.raw)
    XCTAssertTrue(repository.fetchAccessTokenFromPreAuthorizedCodeCalled)
    XCTAssertEqual(mockOpenIdConfiguration.tokenEndpoint, repository.fetchAccessTokenFromPreAuthorizedCodeReceivedArguments?.url)
    XCTAssertTrue(keyPairGenerator.generateIdentifierAlgorithmCalled)
    XCTAssertTrue(fetchAnyCredentialUseCase.executeForCalled)
    XCTAssertEqual(mockMetadataWrapper.selectedCredential?.format, fetchAnyCredentialUseCase.executeForReceivedContext?.format)
    XCTAssertFalse(repository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
    XCTAssertFalse(repository.fetchIssuerPublicKeyInfoFromCalled)

    XCTAssertEqual(analyticsProvider.logCounter, 0)
  }

  func testFetchCredentialSuccess_metaDataClaimNotMatchingVCClaims() async throws {
    let mockWrapper = CredentialMetadataWrapper.Mock.sampleNoClaims
    mockAnyCredential.raw = UUID().uuidString
    let (metadataWrapper, credential, keyPair) = try await useCase.execute(from: mockCredentialOffer)

    XCTAssertEqual(mockAnyCredential.raw, credential.raw)
    XCTAssertEqual(mockKeyPair.algorithm, keyPair?.algorithm)
    XCTAssertEqual(mockKeyPair.identifier, keyPair?.identifier)
    XCTAssertTrue(repository.fetchOpenIdConfigurationFromCalled)
    XCTAssertTrue(repository.fetchAccessTokenFromPreAuthorizedCodeCalled)
    XCTAssertTrue(keyPairGenerator.generateIdentifierAlgorithmCalled)
    XCTAssertTrue(fetchAnyCredentialUseCase.executeForCalled)
    XCTAssertFalse(repository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
    XCTAssertFalse(repository.fetchIssuerPublicKeyInfoFromCalled)

    guard let receivedContext = fetchAnyCredentialUseCase.executeForReceivedContext else {
      XCTFail("receivedContext must not be nill")
      return
    }

    XCTAssertEqual(mockMetadataWrapper.selectedCredential?.format, receivedContext.format)
    XCTAssertEqual(mockKeyPair.privateKey, receivedContext.keyPair?.privateKey)
    XCTAssertEqual(mockAccessToken, receivedContext.accessToken)
    XCTAssertEqual(mockMetadataWrapper.credentialMetadata.credentialEndpoint, receivedContext.credentialEndpoint.absoluteString)

    XCTAssertEqual(analyticsProvider.logCounter, 0)
  }

  func testFetchCredentialFailure_keyPairGeneration() async throws {
    mockAnyCredential.raw = UUID().uuidString
    keyPairGenerator.generateIdentifierAlgorithmThrowableError = NSError()
    do {
      let (metadataWrapper, credential, keyPair) = try await useCase.execute(from: mockCredentialOffer)
    } catch {
      XCTAssertTrue(keyPairGenerator.generateIdentifierAlgorithmCalled)
      XCTAssertFalse(repository.fetchAccessTokenFromPreAuthorizedCodeCalled)
      XCTAssertFalse(fetchAnyCredentialUseCase.executeForCalled)
      XCTAssertFalse(repository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
      XCTAssertFalse(repository.fetchIssuerPublicKeyInfoFromCalled)

      XCTAssertEqual(analyticsProvider.logCounter, 1)
    }
  }

  func testAccessTokenInvalidGrant() async {
    repository.fetchAccessTokenFromPreAuthorizedCodeThrowableError = NetworkError(status: .invalidGrant)

    do {
      _ = try await useCase.execute(from: mockCredentialOffer)
      XCTFail("An error was expected")
    } catch FetchAnyVerifiableCredentialError.expiredInvitation {
      XCTAssertTrue(repository.fetchOpenIdConfigurationFromCalled)
      XCTAssertTrue(repository.fetchAccessTokenFromPreAuthorizedCodeCalled)
      XCTAssertTrue(keyPairGenerator.generateIdentifierAlgorithmCalled)
      XCTAssertFalse(repository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
      XCTAssertFalse(repository.fetchIssuerPublicKeyInfoFromCalled)
      XCTAssertFalse(fetchAnyCredentialUseCase.executeForCalled)
      XCTAssertEqual(analyticsProvider.logCounter, 0)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  func testCredentialEnpoindInvalid() async {
    await testCredentialEnpoindInvalid(endpoint: "")
    await testCredentialEnpoindInvalid(endpoint: "1234")
    await testCredentialEnpoindInvalid(endpoint: "abc/cde")
  }

  func testFetchCredentialThrowsException_withIncorrectPreferredAlgorithms() async throws {
    let mockPreferredAlgos = [JWTAlgorithm.BBS2023]
    Container.shared.preferredKeyBindingAlgorithmsOrdered.register { mockPreferredAlgos }

    useCase = FetchAnyVerifiableCredentialUseCase()

    try await assertUnsupportedAlgorithmException(for: mockMetadataWrapper, preferredAlgos: mockPreferredAlgos)
  }

  func testFetchCredentialThrowsException_withNoMatchablePreferredAlgorithms() async throws {
    let mockPreferredAlgos: [JWTAlgorithm] = []
    Container.shared.preferredKeyBindingAlgorithmsOrdered.register { mockPreferredAlgos }

    useCase = FetchAnyVerifiableCredentialUseCase()

    try await assertUnsupportedAlgorithmException(for: mockMetadataWrapper, preferredAlgos: mockPreferredAlgos)
  }

  func testPreferredKeyBindingAlgorithmPriorisation() async throws {
    let mockPreferredAlgos: [JWTAlgorithm] = [.ES512, .BBS2023, .ES512]
    Container.shared.preferredKeyBindingAlgorithmsOrdered.register { mockPreferredAlgos }

    guard let supportedAlgos = mockMetadataWrapper.selectedCredential?.proofTypesSupported.first?.algorithms else {
      fatalError("Cannot extract supported algorithms")
    }

    useCase = FetchAnyVerifiableCredentialUseCase()

    _ = try await useCase.execute(from: mockCredentialOffer)

    XCTAssertEqual(keyPairGenerator.generateIdentifierAlgorithmReceivedArguments?.algorithm, JWTAlgorithm.ES512.rawValue)
    XCTAssertTrue(supportedAlgos.contains { self.mockpreferredKeyBindingAlgorithmsOrdered.map(\.rawValue).contains($0) })
  }

  // MARK: Private

  private let mockKeyPair = KeyPair(identifier: UUID(), algorithm: "ES256", privateKey: SecKeyTestsHelper.createPrivateKey())
  private let mockResponse = CredentialResponse.Mock.sample
  private let mockIssuerPublicKeyInfo = PublicKeyInfo.Mock.sample
  private let mockAnyCredential = AnyCredentialSpy()
  private let mockOpenIdConfiguration = OpenIdConfiguration.Mock.sample
  private let mockMetadata = CredentialMetadata.Mock.sample
  private let mockMetadataWrapper = CredentialMetadataWrapper.Mock.sample
  private let mockCredentialOffer = CredentialOffer.Mock.sample
  private let mockAccessToken = AccessToken.Mock.sample
  private let mockpreferredKeyBindingAlgorithmsOrdered: [JWTAlgorithm] = [.ES256]
  // swiftlint:disable all
  private let mockUrl = URL(string: "some://url")!
  private var analytics: AnalyticsProtocol!
  private var analyticsProvider: MockProvider!
  // swiftlint:enable all

  private var fetchAnyCredentialUseCase = FetchAnyCredentialUseCaseProtocolSpy()
  private var fetchMetadataUseCase = FetchMetadataUseCaseProtocolSpy()
  private var didJWKGenerator = CredentialDidJWKGeneratorProtocolSpy()
  private var keyPairGenerator = CredentialKeyPairGeneratorProtocolSpy()
  private var repository = OpenIDRepositoryProtocolSpy()
  private var useCase = FetchAnyVerifiableCredentialUseCase()

  private func testCredentialEnpoindInvalid(endpoint: String) async {
    fetchMetadataUseCase.executeFromReturnValue = CredentialMetadata(credentialIssuer: "valid-issuer", credentialEndpoint: endpoint, credentialConfigurationsSupported: [:], display: [])
    do {
      _ = try await useCase.execute(from: mockCredentialOffer)
      XCTFail("Expected a `FetchAnyVerifiableCredentialError.credentialEndpointCreationError`")
    } catch FetchAnyVerifiableCredentialError.credentialEndpointCreationError {
      XCTAssertFalse(repository.fetchOpenIdConfigurationFromCalled)
      XCTAssertFalse(repository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
      XCTAssertFalse(repository.fetchIssuerPublicKeyInfoFromCalled)
      XCTAssertFalse(repository.fetchAccessTokenFromPreAuthorizedCodeCalled)
      XCTAssertFalse(keyPairGenerator.generateIdentifierAlgorithmCalled)
      XCTAssertFalse(didJWKGenerator.generateFromPrivateKeyCalled)
      XCTAssertFalse(fetchAnyCredentialUseCase.executeForCalled)
      XCTAssertEqual(analyticsProvider.logCounter, 0)
    } catch {
      XCTFail("Expected a `FetchAnyVerifiableCredentialError.credentialEndpointCreationError` but got \(error.localizedDescription)")
    }
  }

  private func assertUnsupportedAlgorithmException(for metadataWrapper: CredentialMetadataWrapper, preferredAlgos: [JWTAlgorithm]) async throws {
    guard let supportedAlgos = metadataWrapper.selectedCredential?.proofTypesSupported.first?.algorithms else {
      fatalError("Cannot extract supported algorithms")
    }

    do {
      _ = try await useCase.execute(from: mockCredentialOffer)
      XCTFail("An error was expected")
    } catch FetchAnyVerifiableCredentialError.unsupportedAlgorithm {
      XCTAssertFalse(supportedAlgos.contains { preferredAlgos.map(\.rawValue).contains($0) })
    } catch {
      XCTFail("Not the expected error")
    }
  }

}
