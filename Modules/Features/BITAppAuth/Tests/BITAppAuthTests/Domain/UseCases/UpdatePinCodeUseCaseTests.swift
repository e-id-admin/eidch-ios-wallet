import BITCore
import Factory
import Foundation
import LocalAuthentication
import Spyable
import XCTest
@testable import BITAppAuth
@testable import BITLocalAuthentication

final class UpdatePinCodeUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    context = LAContextProtocolSpy()
    pinCodeManager = PinCodeManagerProtocolSpy()
    userSession = SessionSpy()
    uniquePassphraseManager = UniquePassphraseManagerProtocolSpy()

    Container.shared.internalContext.register { self.context }
    Container.shared.pinCodeManager.register { self.pinCodeManager }
    Container.shared.userSession.register { self.userSession }
    Container.shared.uniquePassphraseManager.register { self.uniquePassphraseManager }

    useCase = UpdatePinCodeUseCase()
  }

  func testHappyPath() throws {
    let pinCodeMockData = Data()
    let uniquePassphraseMockData = Data()
    let pinCode = "123456"

    userSession.startSessionPassphraseCredentialTypeReturnValue = LAContextProtocolSpy()

    pinCodeManager.encryptReturnValue = pinCodeMockData
    uniquePassphraseManager.generateReturnValue = uniquePassphraseMockData

    try useCase.execute(with: pinCode, and: uniquePassphraseMockData)

    XCTAssertTrue(uniquePassphraseManager.saveUniquePassphraseForContextCalled)
    XCTAssertEqual(uniquePassphraseMockData, uniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.uniquePassphrase)
    XCTAssertEqual(AuthMethod.appPin, uniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.authMethod)
    XCTAssertEqual(uniquePassphraseManager.saveUniquePassphraseForContextCallsCount, 1)

    XCTAssertTrue(pinCodeManager.encryptCalled)
    XCTAssertEqual(pinCode, pinCodeManager.encryptReceivedPinCode)

    XCTAssertTrue(userSession.startSessionPassphraseCredentialTypeCalled)
    XCTAssertEqual(userSession.startSessionPassphraseCredentialTypeCallsCount, 2)
    let invocations: [(passphrase: Data, credentialType: LACredentialType)] = [
      (pinCodeMockData, .applicationPassword),
      (uniquePassphraseMockData, .applicationPassword),
    ]
    XCTAssertEqual(invocations[0].passphrase, userSession.startSessionPassphraseCredentialTypeReceivedInvocations[0].passphrase)
    XCTAssertEqual(invocations[1].passphrase, userSession.startSessionPassphraseCredentialTypeReceivedInvocations[1].passphrase)
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: UpdatePinCodeUseCase!
  private var pinCodeManager: PinCodeManagerProtocolSpy!
  private var uniquePassphraseManager: UniquePassphraseManagerProtocolSpy!
  private var userSession: SessionSpy!
  private var context: LAContextProtocolSpy!
  // swiftlint:enable all
}
