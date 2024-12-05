import BITCrypto
import Foundation

class FetchCredentialContext {

  // MARK: Lifecycle

  init(format: String, selectedCredential: any CredentialMetadata.AnyCredentialConfigurationSupported, credentialOffers: [String], credentialIssuer: String, keyPair: KeyPair?, accessToken: AccessToken, credentialEndpoint: URL, createdAt: Date = .now) {
    self.format = format
    self.selectedCredential = selectedCredential
    self.credentialOffers = credentialOffers
    self.credentialIssuer = credentialIssuer
    self.keyPair = keyPair
    self.accessToken = accessToken
    self.credentialEndpoint = credentialEndpoint
    self.createdAt = createdAt
  }

  // MARK: Internal

  let format: String
  let selectedCredential: any CredentialMetadata.AnyCredentialConfigurationSupported
  let credentialOffers: [String]
  let credentialIssuer: String
  let keyPair: KeyPair?
  let createdAt: Date
  let accessToken: AccessToken
  let credentialEndpoint: URL
}
