import Foundation
import Spyable

@Spyable
public protocol FetchMetadataUseCaseProtocol {
  func execute(from issuerUrl: URL) async throws -> CredentialMetadata
}
