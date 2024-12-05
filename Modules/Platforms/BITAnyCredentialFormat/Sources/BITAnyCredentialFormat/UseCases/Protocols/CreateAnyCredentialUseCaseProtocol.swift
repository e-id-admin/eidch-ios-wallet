import Foundation
import Spyable

@Spyable
public protocol CreateAnyCredentialUseCaseProtocol {
  func execute(from payload: CredentialPayload, format: String) throws -> AnyCredential
}
