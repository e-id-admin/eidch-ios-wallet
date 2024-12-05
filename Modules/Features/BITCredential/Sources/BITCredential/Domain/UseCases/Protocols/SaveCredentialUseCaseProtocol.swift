import BITAnyCredentialFormat
import BITCredentialShared
import BITOpenID
import Foundation
import Spyable

// MARK: - SaveCredentialUseCaseProtocol

@Spyable
public protocol SaveCredentialUseCaseProtocol {
  func execute(credentialWithKeyBinding: CredentialWithKeyBinding, metadataWrapper: CredentialMetadataWrapper) async throws -> Credential
}
