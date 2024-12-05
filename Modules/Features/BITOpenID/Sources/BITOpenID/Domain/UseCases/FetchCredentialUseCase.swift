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
  case verificationFailed
}

// MARK: - FetchCredentialUseCase

struct FetchCredentialUseCase: FetchCredentialUseCaseProtocol {

  // MARK: Lifecycle

  init(
    keyPairGenerator: CredentialKeyPairGeneratorProtocol = Container.shared.credentialKeyPairGenerator(),
    fetchAnyCredentialUseCase: FetchAnyCredentialUseCaseProtocol = Container.shared.fetchAnyCredentialUseCase(),
    repository: OpenIDRepositoryProtocol = Container.shared.openIDRepository())
  {
    self.keyPairGenerator = keyPairGenerator
    self.fetchAnyCredentialUseCase = fetchAnyCredentialUseCase
    self.repository = repository
  }

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
      holderBindingKeyPair = try keyPairGenerator.generate(identifier: UUID(), algorithm: algorithm)
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

  private let fetchAnyCredentialUseCase: FetchAnyCredentialUseCaseProtocol
  private let keyPairGenerator: CredentialKeyPairGeneratorProtocol
  private let repository: OpenIDRepositoryProtocol
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
