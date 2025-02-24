import Factory
import XCTest
@testable import BITCore
@testable import BITCredentialShared
@testable import BITOpenID
@testable import BITPresentation

final class GetVerifierDisplayUseCaseTests: XCTestCase {

  // swiftlint:disable all
  var useCase: GetVerifierDisplayUseCase!
  var mockRequestObject = RequestObject.Mock.VcSdJwt.sample
  var preferredUserLanguageCodes: [UserLanguageCode] = []

  var mockITIssuerName = "IT issuer"
  var mockENIssuerName = "EN issuer"

  // swiftlint:enable all

  override func setUp() {
    Container.shared.preferredUserLanguageCodes.register { self.preferredUserLanguageCodes }

    useCase = GetVerifierDisplayUseCase()
  }

  func testExecuteWithoutTrustStatement() {
    let verifierDisplay = useCase.execute(for: mockRequestObject.clientMetadata, trustStatement: nil)

    XCTAssertEqual(verifierDisplay?.trustStatus, .unverified)
  }

  func testExecuteWithTrustStatement_ReturnsPreferredLanguages() {
    preferredUserLanguageCodes = ["en", "de"]

    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot parse trust statement")
    }

    let verifierDisplay = useCase.execute(for: mockRequestObject.clientMetadata, trustStatement: mockTrustStatement)

    XCTAssertEqual(verifierDisplay?.name, mockENIssuerName)
  }

  func testExecuteWithTrustStatement_ReturnsDefaultLanguage() {
    preferredUserLanguageCodes = []

    guard let mockTrustStatement: TrustStatement = .Mock.validSample else {
      fatalError("Cannot parse trust statement")
    }

    let verifierDisplay = useCase.execute(for: mockRequestObject.clientMetadata, trustStatement: mockTrustStatement)

    XCTAssertEqual(verifierDisplay?.name, mockENIssuerName)
  }

  func testExecuteWithTrustStatement_ReturnsIssuerPreferredLanguage() {
    preferredUserLanguageCodes = []

    guard let mockItalianTrustStatement: TrustStatement = .Mock.validSampleItalian else {
      fatalError("Cannot parse trust statement")
    }

    let verifierDisplay = useCase.execute(for: mockRequestObject.clientMetadata, trustStatement: mockItalianTrustStatement)

    XCTAssertEqual(verifierDisplay?.name, mockITIssuerName)
  }

}
