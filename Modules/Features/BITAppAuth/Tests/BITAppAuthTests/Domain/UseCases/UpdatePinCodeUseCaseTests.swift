import BITCore
import Foundation
import Spyable
import XCTest
@testable import BITAppAuth
@testable import BITLocalAuthentication

final class UpdatePinCodeUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    spyContext = LAContextProtocolSpy()
    spyPinCodeManager = PinCodeManagerProtocolSpy()
    spyContextManager = ContextManagerProtocolSpy()
    spyUniquePassphraseManager = UniquePassphraseManagerProtocolSpy()

    useCase = UpdatePinCodeUseCase(
      uniquePassphraseManager: spyUniquePassphraseManager,
      context: spyContext,
      pinCodeManager: spyPinCodeManager,
      contextManager: spyContextManager)
  }

  func testHappyPath() throws {
    let mockData = Data()
    let pinCode = "123456"

    spyPinCodeManager.encryptReturnValue = mockData
    spyUniquePassphraseManager.generateReturnValue = mockData

    try useCase.execute(with: pinCode, and: mockData)

    XCTAssertTrue(spyUniquePassphraseManager.saveUniquePassphraseForContextCalled)
    XCTAssertEqual(mockData, spyUniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.uniquePassphrase)
    XCTAssertEqual(AuthMethod.appPin, spyUniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.authMethod)
    XCTAssertEqual(spyUniquePassphraseManager.saveUniquePassphraseForContextCallsCount, 1)

    XCTAssertTrue(spyPinCodeManager.encryptCalled)
    XCTAssertEqual(pinCode, spyPinCodeManager.encryptReceivedPinCode)

    XCTAssertTrue(spyContextManager.setCredentialContextCalled)
    XCTAssertEqual(mockData, spyContextManager.setCredentialContextReceivedArguments?.data)
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: UpdatePinCodeUseCase!
  private var spyPinCodeManager: PinCodeManagerProtocolSpy!
  private var spyUniquePassphraseManager: UniquePassphraseManagerProtocolSpy!
  private var spyContextManager: ContextManagerProtocolSpy!
  private var spyContext: LAContextProtocolSpy!
  // swiftlint:enable all
}
