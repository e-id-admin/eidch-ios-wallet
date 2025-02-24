import BITCore
import Foundation
import LocalAuthentication
import XCTest
@testable import BITAppAuth
@testable import BITLocalAuthentication

// MARK: - UniquePassphraseManagerTests

final class ContextManagerTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyContext = LAContextProtocolSpy()
    contextManager = ContextManager(credentialType: credentialType)
  }

  func testSetCredentialSuccess() throws {
    let mockData = Data()
    spyContext.setCredentialTypeReturnValue = true

    try contextManager.setCredential(mockData, context: spyContext)
    XCTAssertTrue(spyContext.setCredentialTypeCalled)
    XCTAssertEqual(mockData, spyContext.setCredentialTypeReceivedArguments?.credential)
    XCTAssertEqual(credentialType, spyContext.setCredentialTypeReceivedArguments?.type)
  }

  func testSetCredentialError() throws {
    let mockData = Data()
    spyContext.setCredentialTypeReturnValue = false

    do {
      try contextManager.setCredential(mockData, context: spyContext)
      XCTFail("Should fail instead...")
    } catch AuthError.LAContextError {
      XCTAssertTrue(spyContext.setCredentialTypeCalled)
      XCTAssertEqual(mockData, spyContext.setCredentialTypeReceivedArguments?.credential)
      XCTAssertEqual(credentialType, spyContext.setCredentialTypeReceivedArguments?.type)
    } catch {
      XCTFail("Unexpected error type")
    }
  }

  // MARK: Private

  private let credentialType = LACredentialType.applicationPassword

  // swiftlint:disable all
  private var contextManager: ContextManagerProtocol!
  private var spyContext: LAContextProtocolSpy!
  // swiftlint:enable all
}
