import XCTest

@testable import BITAnyCredentialFormat
@testable import BITAnyCredentialFormatMocks
@testable import BITOpenID

// MARK: - GetVcSdJwtMatchingFieldsUseCaseTests

final class VcSdJwtPresentationFieldsValidatorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    validator = VcSdJwtPresentationFieldsValidator()
  }

  func testExecute_happyPath() throws {
    let mockAnyCredential: AnyCredential = MockAnyCredential()
    let requestFields: [Field] = [.init(path: ["$.hometown", "$.hometown"])]

    let matchingFields = try validator.validate(mockAnyCredential, with: requestFields)

    XCTAssertFalse(matchingFields.isEmpty)
    XCTAssertEqual("Herisau", matchingFields[0].rawValue)
  }

  func testExecute_fieldNotFound() throws {
    let mockAnyCredential: AnyCredential = MockAnyCredential()
    let requestFields: [Field] = [.init(path: ["$.notexistingclaim", "$.notexistingclaim"])]

    let matchingFields = try validator.validate(mockAnyCredential, with: requestFields)

    XCTAssertTrue(matchingFields.isEmpty)
  }

  // MARK: Private

  // swiftlint:disable all
  private var validator: VcSdJwtPresentationFieldsValidator!
  // swiftlint:enable all
}
