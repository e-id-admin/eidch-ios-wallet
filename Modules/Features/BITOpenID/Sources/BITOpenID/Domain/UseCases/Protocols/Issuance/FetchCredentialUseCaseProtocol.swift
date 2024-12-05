import BITAnyCredentialFormat
import Foundation
import Spyable

@Spyable
public protocol FetchCredentialUseCaseProtocol {
  func execute(from issuerUrl: URL, metadataWrapper: CredentialMetadataWrapper, credentialOffer: CredentialOffer, accessToken: AccessToken?) async throws -> CredentialWithKeyBinding
}
