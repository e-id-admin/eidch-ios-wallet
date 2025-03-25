import Factory
import XCTest
@testable import BITCore
@testable import BITCredentialShared
@testable import BITOpenID
@testable import BITPresentation

final class GetVerifierDisplayUseCaseTests: XCTestCase {

  // MARK: Internal

  // swiftlint:disable all
  var useCase: GetVerifierDisplayUseCase!
  var mockRequestObject = RequestObject.Mock.VcSdJwt.sample
  var preferredUserLanguageCodes: [UserLanguageCode] = []

  var mockRequestObjectNameEN = "EN Verifier"
  var mockTrustedNameEN = "EN trusted issuer"
  var mockTrustedNameIT = "IT trusted issuer"

  // swiftlint:enable all

  override func setUp() {
    Container.shared.preferredUserLanguageCodes.register { self.preferredUserLanguageCodes }

    useCase = GetVerifierDisplayUseCase()
  }

  func testExecuteWithoutTrustStatement() {
    let verifierDisplay = useCase.execute(for: mockRequestObject.clientMetadata, trustStatement: nil)

    XCTAssertEqual(verifierDisplay?.trustStatus, .unverified)
    XCTAssertEqual(verifierDisplay?.name, mockRequestObjectNameEN)
    assertVerifierDisplayLogo(verifierDisplay, logoUriDisplay: mockRequestObject.clientMetadata?.logoUri)
  }

  func testExecuteWithTrustStatement_ReturnsPreferredLanguages() {
    preferredUserLanguageCodes = ["en", "de"]

    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot parse trust statement")
    }

    let verifierDisplay = useCase.execute(for: mockRequestObject.clientMetadata, trustStatement: mockTrustStatement)

    XCTAssertEqual(verifierDisplay?.trustStatus, .verified)
    XCTAssertEqual(verifierDisplay?.name, mockTrustedNameEN)
    assertVerifierDisplayLogo(verifierDisplay, logoUriDisplay: mockRequestObject.clientMetadata?.logoUri)
  }

  func testExecuteWithTrustStatement_ReturnsDefaultLanguage() {
    preferredUserLanguageCodes = []

    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot parse trust statement")
    }

    let verifierDisplay = useCase.execute(for: mockRequestObject.clientMetadata, trustStatement: mockTrustStatement)

    XCTAssertEqual(verifierDisplay?.trustStatus, .verified)
    XCTAssertEqual(verifierDisplay?.name, mockTrustedNameEN)
    assertVerifierDisplayLogo(verifierDisplay, logoUriDisplay: mockRequestObject.clientMetadata?.logoUri)
  }

  func testExecuteWithTrustStatement_ReturnsIssuerPreferredLanguage() {
    preferredUserLanguageCodes = []

    guard let mockItalianTrustStatement: TrustStatement = .Mock.validSampleItalian else {
      fatalError("Cannot parse trust statement")
    }

    let verifierDisplay = useCase.execute(for: mockRequestObject.clientMetadata, trustStatement: mockItalianTrustStatement)

    XCTAssertEqual(verifierDisplay?.trustStatus, .verified)
    XCTAssertEqual(verifierDisplay?.name, mockTrustedNameIT)
    assertVerifierDisplayLogo(verifierDisplay, logoUriDisplay: mockRequestObject.clientMetadata?.logoUri)
  }

  // MARK: Private

  /// logo is always taken from request-object. Never from Trust Statement
  private func assertVerifierDisplayLogo(_ verifierDisplay: VerifierDisplay?, logoUriDisplay: Verifier.LocalizedDisplay?) {
    XCTAssertNotNil(verifierDisplay?.logo)
    guard
      let logoUri = Verifier.LocalizedDisplay.getPreferredDisplay(
        from: logoUriDisplay, considering: preferredUserLanguageCodes),
      let decodedURI = CredentialDisplayLogoURIDecoder.decode(logoUri),
      let decodedLogo = Data(base64Encoded: decodedURI)
    else
    {
      XCTFail("Unexpected logoURI from verifierDisplay (ClientMetadata)")
      return
    }

    XCTAssertEqual(verifierDisplay?.logo, decodedLogo)
  }

}
