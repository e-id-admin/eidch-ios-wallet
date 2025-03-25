import BITCrypto
import BITJWT
import BITNetworking
import Factory
import Foundation
import Moya

// MARK: - OpenIdRepositoryError

enum OpenIdRepositoryError: Error {
  case presentationProcessClosed
}

// MARK: - OpenIDRepository

struct OpenIDRepository: OpenIDRepositoryProtocol {

  // MARK: Internal

  func fetchVcSchemaData(from url: URL) async throws -> VcSchema {
    try await networkService.request(OpenIDEndpoint.vcSchema(url: url)).data
  }

  /// Retrieving Type Metadata from a registry given as the url parameter
  /// - Documentation: [SD-JWT-based Verifiable Credentials - Draft 06](https://www.ietf.org/archive/id/draft-ietf-oauth-sd-jwt-vc-06.html#name-from-a-registry)
  func fetchTypeMetadata(from url: URL) async throws -> (TypeMetadata, Data) {
    let response: Response = try await networkService.request(OpenIDEndpoint.typeMetadata(url: url))
    let typeMetadata = try JSONDecoder().decode(TypeMetadata.self, from: response.data)
    return (typeMetadata, response.data)
  }

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
    do {
      return try await networkService.request(OpenIDEndpoint.requestObject(url: url)).data
    } catch let error as NetworkError where error.status == .gone {
      throw OpenIdRepositoryError.presentationProcessClosed
    }
  }

  func fetchTrustStatements(from url: URL, issuerDid: String) async throws -> [String] {
    try await networkService.request(OpenIDEndpoint.trustStatements(url: url, issuerDid: issuerDid))
  }

  // MARK: Private

  @Injected(\NetworkContainer.service) private var networkService: NetworkService
}
