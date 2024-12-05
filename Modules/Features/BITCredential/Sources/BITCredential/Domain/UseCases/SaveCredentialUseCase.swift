import BITAnyCredentialFormat
import BITCredentialShared
import BITOpenID
import Factory
import Foundation

// MARK: - SaveCredentialUseCase

struct SaveCredentialUseCase: SaveCredentialUseCaseProtocol {

  // MARK: Lifecycle

  init(credentialRepository: CredentialRepositoryProtocol = Container.shared.databaseCredentialRepository()) {
    self.credentialRepository = credentialRepository
  }

  // MARK: Internal

  func execute(credentialWithKeyBinding: CredentialWithKeyBinding, metadataWrapper: CredentialMetadataWrapper) async throws -> Credential {
    try await credentialRepository.create(
      credential: Credential(credentialWithKeyBinding: credentialWithKeyBinding, metadataWrapper: metadataWrapper)
    )
  }

  // MARK: Private

  private let credentialRepository: CredentialRepositoryProtocol

}
