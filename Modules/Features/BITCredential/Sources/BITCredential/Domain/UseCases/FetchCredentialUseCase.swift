import BITCredentialShared
import BITOpenID
import Factory
import Foundation
import Spyable

// MARK: - FetchCredentialUseCaseProtocol

@Spyable
public protocol FetchCredentialUseCaseProtocol {
  func execute(from offer: CredentialOffer) async throws -> Credential
}

// MARK: - FetchCredentialUseCase

struct FetchCredentialUseCase: FetchCredentialUseCaseProtocol {
  func execute(from offer: CredentialOffer) async throws -> Credential {
    let (metadataWrapper, credential, keyPair) = try await fetchAnyVerifiableCredentialUseCase.execute(from: offer)

    // OCA

    let savedCredential = try await saveCredentialUseCase.execute(credential: credential, keyPair: keyPair, metadataWrapper: metadataWrapper)

    return (try? await checkAndUpdateCredentialStatusUseCase.execute(for: savedCredential)) ?? savedCredential
  }

  @Injected(\.fetchAnyVerifiableCredentialUseCase) private var fetchAnyVerifiableCredentialUseCase: FetchAnyVerifiableCredentialUseCaseProtocol
  @Injected(\.saveCredentialUseCase) private var saveCredentialUseCase: SaveCredentialUseCaseProtocol
  @Injected(\.checkAndUpdateCredentialStatusUseCase) private var checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol
}
