import BITCrypto
import BITJWT
import Foundation
import Spyable

@Spyable
public protocol OpenIDRepositoryProtocol {
  func fetchMetadata(from issuerUrl: URL) async throws -> CredentialMetadata
  func fetchOpenIdConfiguration(from issuerURL: URL) async throws -> OpenIdConfiguration
  func fetchIssuerPublicKeyInfo(from jwksUrl: URL) async throws -> PublicKeyInfo
  func fetchAccessToken(from url: URL, preAuthorizedCode: String) async throws -> AccessToken
  func fetchCredential(from url: URL, credentialRequestBody: CredentialRequestBody, acccessToken: AccessToken) async throws -> CredentialResponse
  func fetchCredentialStatus(from url: URL) async throws -> JWT
  func fetchRequestObject(from url: URL) async throws -> Data
  func fetchTrustStatements(from url: URL, issuerDid: String) async throws -> [String]
}
