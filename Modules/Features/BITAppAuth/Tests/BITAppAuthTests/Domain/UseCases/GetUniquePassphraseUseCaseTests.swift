import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITLocalAuthentication
@testable import BITTestingCore

final class GetUniquePassphraseUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    spyContext = LAContextProtocolSpy()
    spyPinCodeManager = PinCodeManagerProtocolSpy()
    spyContextManager = ContextManagerProtocolSpy()
    spyUniquePassphraseManager = UniquePassphraseManagerProtocolSpy()

    useCase = GetUniquePassphraseUseCase(
      uniquePassphraseManager: spyUniquePassphraseManager,
      context: spyContext,
      pinCodeManager: spyPinCodeManager,
      contextManager: spyContextManager)
  }

  func testStandardPinCode() throws {
    try testHappyPath(pinCode: "123456")
  }

  func testSpecialCharsPinCode() throws {
    try testHappyPath(pinCode: "aA#$_0")
  }

  func testLongPinCode() throws {
    try testHappyPath(pinCode: "12345678901234567890")
  }

  func testFailurePathWithInvalidPin() throws {
    let mockPinCodeData = Data()
    let pinCode = "121221"

    spyPinCodeManager.encryptReturnValue = mockPinCodeData
    spyUniquePassphraseManager.getUniquePassphraseAuthMethodContextThrowableError = TestingError.error

    do {
      _ = try useCase.execute(from: pinCode)
      XCTFail("Should fail instead...")
    } catch TestingError.error {
      XCTAssertTrue(spyPinCodeManager.encryptCalled)
      XCTAssertTrue(spyContextManager.setCredentialContextCalled)
      XCTAssertEqual(spyContextManager.setCredentialContextCallsCount, 1)
      XCTAssertEqual(pinCode, spyPinCodeManager.encryptReceivedPinCode)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: GetUniquePassphraseUseCase!
  private var spyPinCodeManager: PinCodeManagerProtocolSpy!
  private var spyUniquePassphraseManager: UniquePassphraseManagerProtocolSpy!
  private var spyContextManager: ContextManagerProtocolSpy!
  private var spyContext: LAContextProtocolSpy!

  // swiftlint:enable all

  private func testHappyPath(pinCode: PinCode) throws {
    let mockPinCodeData = Data()
    let mockPassphraseData = Data()

    spyPinCodeManager.encryptReturnValue = mockPinCodeData
    spyUniquePassphraseManager.getUniquePassphraseAuthMethodContextReturnValue = mockPassphraseData

    let passphraseData = try useCase.execute(from: pinCode)

    XCTAssertEqual(passphraseData, mockPassphraseData)
    XCTAssertTrue(spyContextManager.setCredentialContextCalled)
    XCTAssertEqual(mockPinCodeData, spyContextManager.setCredentialContextReceivedArguments?.data)

    XCTAssertTrue(spyPinCodeManager.encryptCalled)
    XCTAssertEqual(pinCode, spyPinCodeManager.encryptReceivedPinCode)

    XCTAssertTrue(spyContextManager.setCredentialContextCalled)
    XCTAssertEqual(spyContextManager.setCredentialContextCallsCount, 1)
    XCTAssertEqual(mockPassphraseData, spyContextManager.setCredentialContextReceivedArguments?.data)
  }

}
