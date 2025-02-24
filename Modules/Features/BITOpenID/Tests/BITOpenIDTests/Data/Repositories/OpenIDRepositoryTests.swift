import BITCore
import BITNetworking
import BITSdJWT
import XCTest
@testable import BITJWT
@testable import BITOpenID
@testable import BITSdJWTMocks

// MARK: - OpenIDCredentialRepository

final class OpenIDCredentialRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = OpenIDRepository()

    NetworkContainer.shared.reset()
    NetworkContainer.shared.stubClosure.register {
      { _ in .immediate }
    }
  }

  // MARK: - Metadata

  func testFetchMetadataSuccess() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }
    let expectedMetadata = CredentialMetadata.Mock.sample

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, CredentialMetadata.Mock.sampleData)
    }

    let metadata = try await repository.fetchMetadata(from: mockUrl)

    XCTAssertEqual(expectedMetadata.credentialEndpoint, metadata.credentialEndpoint)
    XCTAssertEqual(expectedMetadata.credentialIssuer, metadata.credentialIssuer)
    XCTAssertEqual(expectedMetadata.credentialConfigurationsSupported.count, metadata.credentialConfigurationsSupported.count)
    XCTAssertEqual(expectedMetadata.display.count, metadata.display.count)
    XCTAssertEqual(expectedMetadata.preferredDisplay, metadata.preferredDisplay)
  }

  func testFetchMetadataNetworkError() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, Data())
    }

    do {
      _ = try await repository.fetchMetadata(from: mockUrl)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  // MARK: - OpenIdConfiguration

  func testFetchOpenIdConfigurationSuccess() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }
    let expectedConfiguration = OpenIdConfiguration.Mock.sample

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, OpenIdConfiguration.Mock.sampleData)
    }

    let configuration = try await repository.fetchOpenIdConfiguration(from: mockUrl)

    XCTAssertEqual(expectedConfiguration, configuration)
  }

  func testFetchOpenIdConfigurationNetworkError() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, Data())
    }

    do {
      _ = try await repository.fetchOpenIdConfiguration(from: mockUrl)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  // MARK: - AccessToken

  func testFetchAccessToken_success() async throws {
    guard let mockURL = URL(string: strURL) else { fatalError("url building") }
    let preAuthorizedCode = "code"
    let expectedAccessToken = AccessToken.Mock.sample

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, AccessToken.Mock.sampleData)
    }

    let accessToken = try await repository.fetchAccessToken(from: mockURL, preAuthorizedCode: preAuthorizedCode)

    XCTAssertEqual(expectedAccessToken.accessToken, accessToken.accessToken)
    XCTAssertEqual(expectedAccessToken.cNonce, accessToken.cNonce)
  }

  func testFetchAccessToken_invalidGrant() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }
    let preAuthorizedCode = "code"

    let mockInvalidGandError = ["error": "invalid_grant"]
    let mockInvalidGandErrorData = try JSONEncoder().encode(mockInvalidGandError)
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(400, mockInvalidGandErrorData)
    }

    do {
      _ = try await repository.fetchAccessToken(from: mockUrl, preAuthorizedCode: preAuthorizedCode)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .invalidGrant)
    }
  }

  func testFetchAccessToken_unknownBadRequest() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }
    let preAuthorizedCode = "code"

    let mockInvalidGandError = ["error": "something_unknown"]
    let mockInvalidGandErrorData = try JSONEncoder().encode(mockInvalidGandError)
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(400, mockInvalidGandErrorData)
    }

    do {
      _ = try await repository.fetchAccessToken(from: mockUrl, preAuthorizedCode: preAuthorizedCode)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertNotEqual(error.status, .invalidGrant)
    }
  }

  func testFetchAccessToken_failure() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }
    let preAuthorizedCode = "code"

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, Data())
    }

    do {
      _ = try await repository.fetchAccessToken(from: mockUrl, preAuthorizedCode: preAuthorizedCode)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  // MARK: - Credential

  func testFetchCredential_success() async throws {
    guard let mockURL = URL(string: strURL) else { fatalError("url building") }

    let accessToken = AccessToken.Mock.sample
    let credentialRequestBody = CredentialRequestBody.Mock.sample

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, CredentialResponse.Mock.sampleData)
    }
    let expectedCredential = VcSdJwt.Mock.sample

    let credentialResponse = try await repository.fetchCredential(from: mockURL, credentialRequestBody: credentialRequestBody, acccessToken: accessToken)
    XCTAssertEqual(credentialResponse.rawCredential, expectedCredential.raw)
    XCTAssertNil(credentialResponse.transactionId)
    XCTAssertNil(credentialResponse.cNonce)
    XCTAssertNil(credentialResponse.cNonceExpiresIn)
    guard let vcSdJwt = try? VcSdJwt(from: credentialResponse.rawCredential) else {
      XCTFail("The credential received can't be converted in a SD-JWT")
      return
    }
    XCTAssertEqual(vcSdJwt.claims.count, expectedCredential.claims.count)
  }

  func testFetchCredential_failure() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }

    let accessToken = AccessToken.Mock.sample
    let credentialRequestBody = CredentialRequestBody.Mock.sample

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, Data())
    }

    do {
      _ = try await repository.fetchCredential(from: mockUrl, credentialRequestBody: credentialRequestBody, acccessToken: accessToken)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  // MARK: - Status

  func testFetchCredentialStatus_success() async throws {
    guard let mockURL = URL(string: strURL) else { fatalError("url building") }
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, JWT.Mock.validStatusSampleData)
    }
    let expectedJWT = JWT.Mock.validStatusSample
    let jwt = try await repository.fetchCredentialStatus(from: mockURL)
    XCTAssertEqual(jwt, expectedJWT)
  }

  func testFetchCredentialStatus_failure() async throws {
    guard let mockURL = URL(string: strURL) else { fatalError("url building") }

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, Data())
    }

    do {
      _ = try await repository.fetchCredentialStatus(from: mockURL)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  // MARK: - RequestObject

  func testFetchRequestObjetSuccess() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }
    let expectedRequestObject = RequestObject.Mock.VcSdJwt.jsonSampleData

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, RequestObject.Mock.VcSdJwt.jsonSampleData)
    }

    let requestObject = try await repository.fetchRequestObject(from: mockUrl)

    XCTAssertEqual(String(data: requestObject, encoding: .utf8), String(data: expectedRequestObject, encoding: .utf8))
  }

  func testFetchRequestObjetFailure() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, Data())
    }

    do {
      _ = try await repository.fetchRequestObject(from: mockUrl)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  // MARK: - Trust Statements

  func testTrustStatementsSuccess() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }
    let expectedStatements: [String] = [ TrustStatement.Mock.sdJwtSample, TrustStatement.Mock.sdJwtSample]
    let mockStatementData = try JSONEncoder().encode(expectedStatements)

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, mockStatementData)
    }

    let trustStatements = try await repository.fetchTrustStatements(from: mockUrl, issuerDid: "did")

    XCTAssertEqual(expectedStatements, trustStatements)
  }

  func testTrustStatementsNetworkError() async throws {
    guard let mockUrl = URL(string: strURL) else { fatalError("url building") }
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, Data())
    }

    do {
      _ = try await repository.fetchTrustStatements(from: mockUrl, issuerDid: "did")
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  // MARK: Private

  private let strURL = "some://url"
  private var repository = OpenIDRepository()
}
