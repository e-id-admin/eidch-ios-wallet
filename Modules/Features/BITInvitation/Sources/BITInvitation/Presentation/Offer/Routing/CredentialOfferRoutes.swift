import BITCredentialShared
import BITNavigation
import BITOpenID

// MARK: - CredentialOfferRoutes

public protocol CredentialOfferRoutes {
  func credentialOffer(credential: Credential, trustStatement: TrustStatement?)
}

// MARK: - CredentialOfferInternalRoutes

protocol CredentialOfferInternalRoutes: ClosableRoutes, ExternalRoutes {
  func wrongData()
}
