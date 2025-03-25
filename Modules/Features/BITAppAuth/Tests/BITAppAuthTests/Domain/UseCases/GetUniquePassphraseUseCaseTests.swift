import Factory
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

    context = LAContextProtocolSpy()
    pinCodeManager = PinCodeManagerProtocolSpy()
    uniquePassphraseManager = UniquePassphraseManagerProtocolSpy()

    Container.shared.internalContext.register { self.context }
    Container.shared.pinCodeManager.register { self.pinCodeManager }
    Container.shared.uniquePassphraseManager.register { self.uniquePassphraseManager }

    useCase = GetUniquePassphraseUseCase()
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

    context.setCredentialTypeReturnValue = true
    pinCodeManager.encryptReturnValue = mockPinCodeData
    uniquePassphraseManager.getUniquePassphraseAuthMethodContextThrowableError = TestingError.error

    do {
      _ = try useCase.execute(from: pinCode)
      XCTFail("Should fail instead...")
    } catch TestingError.error {
      XCTAssertTrue(pinCodeManager.encryptCalled)
      XCTAssertTrue(context.setCredentialTypeCalled)
      XCTAssertEqual(context.setCredentialTypeCallsCount, 1)
      XCTAssertEqual(pinCode, pinCodeManager.encryptReceivedPinCode)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: GetUniquePassphraseUseCase!
  private var pinCodeManager: PinCodeManagerProtocolSpy!
  private var uniquePassphraseManager: UniquePassphraseManagerProtocolSpy!
  private var context: LAContextProtocolSpy!

  // swiftlint:enable all

  private func testHappyPath(pinCode: PinCode) throws {
    let mockPinCodeData = Data()
    let mockPassphraseData = Data()

    context.setCredentialTypeReturnValue = true
    pinCodeManager.encryptReturnValue = mockPinCodeData
    uniquePassphraseManager.getUniquePassphraseAuthMethodContextReturnValue = mockPassphraseData

    let passphraseData = try useCase.execute(from: pinCode)

    XCTAssertEqual(passphraseData, mockPassphraseData)
    XCTAssertTrue(context.setCredentialTypeCalled)
    XCTAssertEqual(mockPinCodeData, context.setCredentialTypeReceivedArguments?.credential)

    XCTAssertTrue(pinCodeManager.encryptCalled)
    XCTAssertEqual(pinCode, pinCodeManager.encryptReceivedPinCode)

    XCTAssertTrue(context.setCredentialTypeCalled)
    XCTAssertEqual(context.setCredentialTypeCallsCount, 1)
    XCTAssertEqual(mockPassphraseData, context.setCredentialTypeReceivedArguments?.credential)
  }

}
