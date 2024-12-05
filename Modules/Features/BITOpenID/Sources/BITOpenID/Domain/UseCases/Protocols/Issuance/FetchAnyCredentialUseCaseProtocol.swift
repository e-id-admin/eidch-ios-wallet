import BITAnyCredentialFormat
import Foundation
import Spyable

@Spyable
protocol FetchAnyCredentialUseCaseProtocol {
  func execute(for context: FetchCredentialContext) async throws -> AnyCredential
}
