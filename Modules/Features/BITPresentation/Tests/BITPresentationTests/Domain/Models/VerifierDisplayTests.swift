import Factory
import XCTest

@testable import BITCore
@testable import BITOpenID
@testable import BITPresentation

final class VerifierDisplayTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    Container.shared.preferredUserLanguageCodes.register {
      self.preferredUserLanguageCodes
    }
  }

  // Returns preferred item (based on user languages)
  func testInitVerifierDisplayWithVerifier_withPreferredLanguages() {
    let mockRequestObject: RequestObject = .Mock.VcSdJwt.sample
    preferredUserLanguageCodes = ["fr", "de"]

    let verifiedDisplay: VerifierDisplay = .init(verifier: mockRequestObject.clientMetadata, trustStatus: .verified)

    XCTAssertEqual(verifiedDisplay.name, "FR Verifier")
    XCTAssertEqual(verifiedDisplay.logoUri, URL(string: "www.examle.com/french-logo.png"))
  }

  // Returns `EN` item
  func testInitVerifierDisplayWithVerifier_withoutPreferredLanguages_withDefaultLanguage() {
    let mockRequestObject: RequestObject = .Mock.VcSdJwt.sample
    preferredUserLanguageCodes = []

    let verifiedDisplay: VerifierDisplay = .init(verifier: mockRequestObject.clientMetadata, trustStatus: .verified)

    XCTAssertEqual(verifiedDisplay.name, "EN Verifier")
    XCTAssertEqual(verifiedDisplay.logoUri, URL(string: "www.examle.com/english-logo.png"))
  }

  // Returns the item without #localization
  func testInitVerifierDisplayWithVerifier_withoutPreferredLanguages_withFallback() {
    let mockRequestObject: RequestObject = .Mock.VcSdJwt.sampleWithoutInputDescriptors
    preferredUserLanguageCodes = []

    let verifiedDisplay: VerifierDisplay = .init(verifier: mockRequestObject.clientMetadata, trustStatus: .verified)

    XCTAssertEqual(verifiedDisplay.name, "Verifier")
    XCTAssertEqual(verifiedDisplay.logoUri, URL(string: "www.examle.com/logo.png"))
  }

  #warning("TODO: Update after having default fallback value in EIDPERA-1685")
  // Returns fallback text
  func testInitVerifierDisplayWithVerifier_withoutLanguages() {
    let mockRequestObjectData = RequestObject.Mock.VcSdJwt.sampleWithUnsupportedClientMetadata
    let mockRequestObject = try? JSONDecoder().decode(RequestObject.self, from: mockRequestObjectData)
    preferredUserLanguageCodes = []

    let verifiedDisplay: VerifierDisplay = .init(verifier: mockRequestObject?.clientMetadata, trustStatus: .verified)

    XCTAssertTrue(verifiedDisplay.name?.isEmpty ?? true)
    XCTAssertNil(verifiedDisplay.logoUri)
  }

  // MARK: Private

  private var preferredUserLanguageCodes: [UserLanguageCode] = []

}
