import BITAnyCredentialFormat
import BITCredentialShared
import BITCrypto
import BITOpenID
import Factory
import Foundation
import Spyable

// MARK: - SaveCredentialUseCaseProtocol

@Spyable
public protocol SaveCredentialUseCaseProtocol {
  func execute(credential: AnyCredential, keyPair: KeyPair?, metadataWrapper: CredentialMetadataWrapper) async throws -> Credential
}

// MARK: - SaveCredentialUseCase

struct SaveCredentialUseCase: SaveCredentialUseCaseProtocol {

  // MARK: Internal

  func execute(credential: AnyCredential, keyPair: KeyPair?, metadataWrapper: CredentialMetadataWrapper) async throws -> Credential {
    let credential = try Credential(anyCredential: credential, keyPair: keyPair, metadataWrapper: metadataWrapper)
    return try await credentialRepository.create(credential: credential)
  }

  // MARK: Private

  @Injected(\.databaseCredentialRepository) private var credentialRepository: CredentialRepositoryProtocol

}
