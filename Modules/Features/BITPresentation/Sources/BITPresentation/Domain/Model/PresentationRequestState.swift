import BITCredentialShared

// MARK: - PresentationRequestResultState

public enum PresentationRequestResultState: Equatable {
  case success(claims: [CredentialClaim])
  case invalidCredential(claims: [CredentialClaim])
  case deny
  case error
  case cancelled
}
