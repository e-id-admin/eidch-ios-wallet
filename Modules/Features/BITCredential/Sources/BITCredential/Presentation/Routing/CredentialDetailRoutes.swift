import BITCredentialShared
import BITNavigation

// MARK: - CredentialDetailRoutes

public protocol CredentialDetailRoutes {
  func credentialDetail(_ credential: Credential)
}

// MARK: - CredentialDetailInternalRoutes

protocol CredentialDetailInternalRoutes: ClosableRoutes, ExternalRoutes {
  func wrongData()
}
