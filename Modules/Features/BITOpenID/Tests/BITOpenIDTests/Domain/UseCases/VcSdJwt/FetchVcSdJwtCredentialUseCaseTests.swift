import Spyable
import XCTest

@testable import BITAnyCredentialFormat
@testable import BITCrypto
@testable import BITJWT
@testable import BITOpenID

@testable import BITSdJWT
@testable import BITSdJWTMocks

// MARK: - FetchVcSdJwtCredentialUseCaseTests

final class FetchVcSdJwtCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyJWTSignatureValidator = JWTSignatureValidatorProtocolSpy()
    spyRepository = OpenIDRepositoryProtocolSpy()
    jwtContextHelper = JWTContextHelperProtocolSpy()
    useCase = FetchVcSdJwtCredentialUseCase(
      jwtSignatureValidator: spyJWTSignatureValidator,
      repository: spyRepository,
      jwtContextHelper: jwtContextHelper)

    mockFetchCredentialContext = .Mock.sampleVcSdJwt
  }

  func testFetchHappyPath() async throws {
    let mockJWT: JWT = .Mock.sample
    let mockCredentialResponse: CredentialResponse = .Mock.sample

    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockCredentialResponse
    spyJWTSignatureValidator.validateDidKidReturnValue = true
    jwtContextHelper.jwtUsingKeyPairTypeReturnValue = mockJWT

    _ = try await useCase.execute(for: mockFetchCredentialContext)

    if let fetchArguments = spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReceivedArguments {
      XCTAssertEqual(fetchArguments.url, mockFetchCredentialContext.credentialEndpoint)
      XCTAssertEqual(fetchArguments.acccessToken, mockFetchCredentialContext.accessToken)
      XCTAssertEqual(fetchArguments.credentialRequestBody.format, mockFetchCredentialContext.format)
      XCTAssertEqual(fetchArguments.credentialRequestBody.proof?.proofType, "jwt")
      XCTAssertEqual(fetchArguments.credentialRequestBody.proof?.jwt, mockJWT.raw)
    } else {
      XCTFail("fetchCredential no arguments received")
    }

    XCTAssertEqual(spyJWTSignatureValidator.validateDidKidReceivedArguments?.jwt.raw, mockCredentialResponse.rawCredential)
  }

  func testFetchHappyPathWithoutHolderBinding() async throws {
    let mockCredentialResponse: CredentialResponse = .Mock.sample
    let context = FetchCredentialContext.Mock.sampleVcSdJwtWithoutHolderBinding

    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockCredentialResponse
    spyJWTSignatureValidator.validateDidKidReturnValue = true

    _ = try await useCase.execute(for: context)

    if let fetchArguments = spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReceivedArguments {
      XCTAssertEqual(fetchArguments.url, mockFetchCredentialContext.credentialEndpoint)
      XCTAssertEqual(fetchArguments.acccessToken, mockFetchCredentialContext.accessToken)
      XCTAssertEqual(fetchArguments.credentialRequestBody.format, mockFetchCredentialContext.format)
      XCTAssertNil(fetchArguments.credentialRequestBody.proof)
    } else {
      XCTFail("fetchCredential no arguments received")
    }

    XCTAssertEqual(spyJWTSignatureValidator.validateDidKidReceivedArguments?.jwt.raw, mockCredentialResponse.rawCredential)
    XCTAssertNil(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReceivedArguments?.credentialRequestBody.proof)
  }

  func testCredentialValidation_fails() async throws {
    let mockJWT: JWT = .Mock.sample
    let mockCredentialResponse: CredentialResponse = .Mock.sample

    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockCredentialResponse
    spyJWTSignatureValidator.validateDidKidReturnValue = false
    jwtContextHelper.jwtUsingKeyPairTypeReturnValue = mockJWT

    do {
      _ = try await useCase.execute(for: mockFetchCredentialContext)
      XCTFail("An error was expected")
    } catch FetchCredentialError.verificationFailed {
      if let fetchArguments = spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReceivedArguments {
        XCTAssertEqual(fetchArguments.url, mockFetchCredentialContext.credentialEndpoint)
        XCTAssertEqual(fetchArguments.acccessToken, mockFetchCredentialContext.accessToken)
        XCTAssertEqual(fetchArguments.credentialRequestBody.format, mockFetchCredentialContext.format)
        XCTAssertEqual(fetchArguments.credentialRequestBody.proof?.proofType, "jwt")
        XCTAssertEqual(fetchArguments.credentialRequestBody.proof?.jwt, mockJWT.raw)
      } else {
        XCTFail("fetchCredential no arguments received")
      }

      XCTAssertEqual(spyJWTSignatureValidator.validateDidKidReceivedArguments?.jwt.raw, mockCredentialResponse.rawCredential)
      XCTAssertEqual(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReceivedArguments?.credentialRequestBody.proof?.jwt, mockJWT.raw)
    } catch {
      XCTFail("Another error was expected")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: FetchVcSdJwtCredentialUseCase!
  private var spyJWTSignatureValidator: JWTSignatureValidatorProtocolSpy!
  private var spyRepository: OpenIDRepositoryProtocolSpy!
  private var mockFetchCredentialContext: FetchCredentialContext!
  private var jwtContextHelper: JWTContextHelperProtocolSpy!
  // swiftlint:enable all
}
