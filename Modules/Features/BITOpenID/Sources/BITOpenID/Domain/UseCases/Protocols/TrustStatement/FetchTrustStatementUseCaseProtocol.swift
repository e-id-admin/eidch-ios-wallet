import BITAnyCredentialFormat
import Spyable

@Spyable
public protocol FetchTrustStatementUseCaseProtocol {
  func execute(credential: AnyCredential) async throws -> TrustStatement?
  func execute(jwtRequestObject: JWTRequestObject) async throws -> TrustStatement?
}
