import Factory
import XCTest

@testable import BITCore
@testable import BITCredentialShared
@testable import BITInvitation
@testable import BITOpenID

final class GetCredentialIssuerDisplayUseCaseTests: XCTestCase {

  // swiftlint:disable all
  var useCase: GetCredentialIssuerDisplayUseCase!
  var mockCredential: Credential = .Mock.sample
  var preferredUserLanguageCodes: [UserLanguageCode] = []

  var mockITIssuerName: String = "IT issuer"
  var mockENIssuerName: String = "EN issuer"

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
    XCTAssertEqual(issuer?.name, mockENIssuerName)
  }

  func testExecuteWithTrustStatement_ReturnsDefaultLanguage() {
    preferredUserLanguageCodes = []

    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot parse trust statement")
    }

    let issuer = useCase.execute(for: mockCredential, trustStatement: mockTrustStatement)

    XCTAssertNotEqual(issuer, mockCredential.preferredIssuerDisplay)
    XCTAssertEqual(issuer?.name, mockENIssuerName)
  }

  func testExecuteWithTrustStatement_ReturnsIssuerPreferredLanguage() {
    preferredUserLanguageCodes = []

    guard let mockItalianTrustStatement: TrustStatement = .Mock.validSampleItalian else {
      fatalError("Cannot parse trust statement")
    }

    let issuer = useCase.execute(for: mockCredential, trustStatement: mockItalianTrustStatement)

    XCTAssertNotEqual(issuer, mockCredential.preferredIssuerDisplay)
    XCTAssertEqual(issuer?.name, mockITIssuerName)
  }

}
