import BITAnalytics
import BITAnyCredentialFormat
import BITCrypto
import BITJWT
import BITNetworking
import Factory
import Foundation

// MARK: - FetchCredentialError

public enum FetchCredentialError: Error {
  case unsupportedAlgorithm
  case credentialEndpointCreationError
  case expiredInvitation
  case noSelectedCredential
  case selectedCredentialNotFound
  case unknownIssuer
  case validationFailed
}

// MARK: - FetchCredentialUseCase

struct FetchCredentialUseCase: FetchCredentialUseCaseProtocol {

  // MARK: Internal

  func execute(from issuerUrl: URL, metadataWrapper: CredentialMetadataWrapper, credentialOffer: CredentialOffer, accessToken: AccessToken?) async throws -> CredentialWithKeyBinding {
    guard let credentialEndpoint = URL(string: metadataWrapper.credentialMetadata.credentialEndpoint) else {
      throw FetchCredentialError.credentialEndpointCreationError
    }
    guard
      let rawCredentialFormat = metadataWrapper.selectedCredential?.format,
      let selectedCredential = metadataWrapper.selectedCredential else
    {
      throw FetchCredentialError.selectedCredentialNotFound
    }

    var holderBindingKeyPair: KeyPair? = nil
    if
      let proofTypes = metadataWrapper.selectedCredential?.proofTypesSupported,
      proofTypes.isEmpty == false,
      let algorithm = proofTypes.first?.algorithms.first
    {
      do {
        holderBindingKeyPair = try keyPairGenerator.generate(identifier: UUID(), algorithm: algorithm)
      } catch {
        analytics.log(error)
        throw error
      }
    }

    let configuration = try await repository.fetchOpenIdConfiguration(from: issuerUrl)

    let retrievedAccessToken = try await fetchAccessToken(considering: accessToken, tokenEndpoint: configuration.tokenEndpoint, credentialOffer: credentialOffer)

    let context = FetchCredentialContext(
      format: rawCredentialFormat,
      selectedCredential: selectedCredential,
      credentialOffers: credentialOffer.credentialConfigurationIds,
      credentialIssuer: metadataWrapper.credentialMetadata.credentialIssuer,
      keyPair: holderBindingKeyPair,
      accessToken: retrievedAccessToken,
      credentialEndpoint: credentialEndpoint)
    let anyCredential = try await fetchAnyCredentialUseCase.execute(for: context)
    return CredentialWithKeyBinding(anyCredential: anyCredential, boundTo: holderBindingKeyPair)
  }

  // MARK: Private

  @Injected(\.fetchAnyCredentialUseCase) private var fetchAnyCredentialUseCase: FetchAnyCredentialUseCaseProtocol
  @Injected(\.credentialKeyPairGenerator) private var keyPairGenerator: CredentialKeyPairGeneratorProtocol
  @Injected(\.openIDRepository) private var repository: OpenIDRepositoryProtocol
  @Injected(\.analytics) private var analytics: AnalyticsProtocol
}

extension FetchCredentialUseCase {

  private func fetchAccessToken(considering accessToken: AccessToken?, tokenEndpoint: URL, credentialOffer: CredentialOffer) async throws -> AccessToken {
    if let accessToken {
      return accessToken
    }
    do {
      return try await repository.fetchAccessToken(from: tokenEndpoint, preAuthorizedCode: credentialOffer.preAuthorizedCode)
    } catch {
      guard let err = error as? NetworkError, err.status == .invalidGrant else { throw error }
      throw FetchCredentialError.expiredInvitation
    }
  }

}
