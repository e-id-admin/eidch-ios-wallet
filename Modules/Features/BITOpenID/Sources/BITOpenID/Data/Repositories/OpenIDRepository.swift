import BITCrypto
import BITJWT
import BITNetworking
import Factory
import Foundation

// MARK: - OpenIDRepository

struct OpenIDRepository: OpenIDRepositoryProtocol {

  // MARK: Internal

  func fetchMetadata(from issuerUrl: URL) async throws -> CredentialMetadata {
    try await networkService.request(OpenIDEndpoint.metadata(fromIssuerUrl: issuerUrl))
  }

  func fetchOpenIdConfiguration(from issuerURL: URL) async throws -> OpenIdConfiguration {
    try await networkService.request(OpenIDEndpoint.openIdConfiguration(issuerURL: issuerURL))
  }

  func fetchIssuerPublicKeyInfo(from jwksUrl: URL) async throws -> PublicKeyInfo {
    try await networkService.request(OpenIDEndpoint.publicKeyInfo(jwksUrl: jwksUrl))
  }

  func fetchAccessToken(from url: URL, preAuthorizedCode: String) async throws -> AccessToken {
    try await networkService.request(OpenIDEndpoint.accessToken(fromTokenUrl: url, preAuthorizedCode: preAuthorizedCode))
  }

  func fetchCredential(from url: URL, credentialRequestBody: CredentialRequestBody, acccessToken: AccessToken) async throws -> CredentialResponse {
    try await networkService.request(OpenIDEndpoint.credential(url: url, body: credentialRequestBody, acccessToken: acccessToken.accessToken))
  }

  func fetchCredentialStatus(from url: URL) async throws -> JWT {
    let response = try await networkService.request(OpenIDEndpoint.status(url: url))
    let raw = String(data: response.data, encoding: .utf8) ?? ""
    return try JWT(from: raw)
  }

  func fetchRequestObject(from url: URL) async throws -> Data {
    try await networkService.request(OpenIDEndpoint.requestObject(url: url)).data
  }

  func fetchTrustStatements(from url: URL, issuerDid: String) async throws -> [String] {
    try await networkService.request(OpenIDEndpoint.trustStatements(url: url, issuerDid: issuerDid))
  }

  // MARK: Private

  @Injected(\NetworkContainer.service) private var networkService: NetworkService
}
