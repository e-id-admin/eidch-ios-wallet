import Factory
import XCTest
@testable import BITCore
@testable import BITCredentialShared
@testable import BITInvitation
@testable import BITOpenID

final class GetCredentialIssuerDisplayUseCaseTests: XCTestCase {

  // MARK: Internal

  // swiftlint:disable all
  var useCase: GetCredentialIssuerDisplayUseCase!
  var mockCredential = Credential.Mock.sample
  var preferredUserLanguageCodes: [UserLanguageCode] = []

  var mockITIssuerName = "IT trusted issuer"
  var mockENIssuerName = "EN trusted issuer"

  // swiftlint:enable all

  override func setUp() {
    Container.shared.preferredUserLanguageCodes.register { self.preferredUserLanguageCodes }

    useCase = GetCredentialIssuerDisplayUseCase()
  }

  func testExecuteWithTrustStatement_ReturnsPreferredLanguages() {
    preferredUserLanguageCodes = ["en", "de"]

    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot parse trust statement")
    }

    let issuer = useCase.execute(for: mockCredential, trustStatement: mockTrustStatement)

    XCTAssertNotEqual(issuer, mockCredential.preferredIssuerDisplay)
    XCTAssertNotEqual(issuer?.name, mockCredential.preferredIssuerDisplay?.name)
    XCTAssertEqual(issuer?.name, mockENIssuerName)
    assertCredentialIssuerDisplayImage(from: issuer, preferredIssuerDisplay: mockCredential.preferredIssuerDisplay)
  }

  func testExecuteWithTrustStatement_ReturnsDefaultLanguage() {
    preferredUserLanguageCodes = []

    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot parse trust statement")
    }

    let issuer = useCase.execute(for: mockCredential, trustStatement: mockTrustStatement)

    XCTAssertNotEqual(issuer, mockCredential.preferredIssuerDisplay)
    XCTAssertNotEqual(issuer?.name, mockCredential.preferredIssuerDisplay?.name)
    XCTAssertEqual(issuer?.name, mockENIssuerName)
    assertCredentialIssuerDisplayImage(from: issuer, preferredIssuerDisplay: mockCredential.preferredIssuerDisplay)
  }

  func testExecuteWithTrustStatement_ReturnsIssuerPreferredLanguage() {
    preferredUserLanguageCodes = []

    guard let mockItalianTrustStatement: TrustStatement = .Mock.validSampleItalian else {
      fatalError("Cannot parse trust statement")
    }

    let issuer = useCase.execute(for: mockCredential, trustStatement: mockItalianTrustStatement)

    XCTAssertNotEqual(issuer, mockCredential.preferredIssuerDisplay)
    XCTAssertNotEqual(issuer?.name, mockCredential.preferredIssuerDisplay?.name)
    XCTAssertEqual(issuer?.name, mockITIssuerName)
    assertCredentialIssuerDisplayImage(from: issuer, preferredIssuerDisplay: mockCredential.preferredIssuerDisplay)
  }

  // MARK: Private

  /// image is always taken from preferredIssuerDisplay (source is OID metadata). Never from Trust Statement
  private func assertCredentialIssuerDisplayImage(from issuerDisplay: CredentialIssuerDisplay?, preferredIssuerDisplay: CredentialIssuerDisplay?) {
    XCTAssertNotNil(issuerDisplay?.image)
    XCTAssertEqual(issuerDisplay?.image, preferredIssuerDisplay?.image)
  }

}
