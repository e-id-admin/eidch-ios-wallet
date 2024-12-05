import BITCredentialShared
import BITOpenID
import Spyable

@Spyable
protocol GetCredentialIssuerDisplayUseCaseProtocol {
  func execute(for credential: Credential, trustStatement: TrustStatement) -> CredentialIssuerDisplay?
}
