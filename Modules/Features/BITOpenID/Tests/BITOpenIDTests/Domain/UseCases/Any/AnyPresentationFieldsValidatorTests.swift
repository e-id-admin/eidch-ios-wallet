import Spyable
import XCTest

@testable import BITAnyCredentialFormat
@testable import BITAnyCredentialFormatMocks
@testable import BITCore
@testable import BITOpenID

final class AnyPresentationFieldsValidatorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    anyPresentationFieldsValidatorProtocolSpy = AnyPresentationFieldsValidatorProtocolSpy()
    validator = AnyPresentationFieldsValidator(anyPresentationFieldsValidatorDispatcher: [.vcSdJwt: anyPresentationFieldsValidatorProtocolSpy])
  }

  func testExecuteVcSdJwtUseCase() throws {
    let anycredential: AnyCredential = MockAnyCredential()
    let mockCodableValues: [CodableValue] = [
      .init(value: "value", as: "string"),
    ]

    anyPresentationFieldsValidatorProtocolSpy.validateWithReturnValue = mockCodableValues

    let matchingFields = try validator.validate(anycredential, with: [
      .init(path: ["path"]),
    ])

    XCTAssertTrue(anyPresentationFieldsValidatorProtocolSpy.validateWithCalled)
    XCTAssertEqual(matchingFields.count, mockCodableValues.count)
  }

  func testExecuteUnsupportedFormat() throws {
    let anycredential: AnyCredential = OtherMockAnyCredential()
    anyPresentationFieldsValidatorProtocolSpy.validateWithReturnValue = []

    do {
      _ = try validator.validate(anycredential, with: [])
      XCTFail("An error was expected")
    } catch CredentialFormatError.formatNotSupported {
      XCTAssertFalse(anyPresentationFieldsValidatorProtocolSpy.validateWithCalled)
    } catch {
      XCTFail("Another error was expected")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var validator: AnyPresentationFieldsValidator!
  private var anyPresentationFieldsValidatorProtocolSpy: AnyPresentationFieldsValidatorProtocolSpy!
  // swiftlint:enable all
}
