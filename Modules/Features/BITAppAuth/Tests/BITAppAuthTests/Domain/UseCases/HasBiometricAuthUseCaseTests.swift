import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITLocalAuthentication
@testable import BITTestingCore

final class HasBiometricAuthUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    spyContext = LAContextProtocolSpy()
    spyPolicyValidator = LocalAuthenticationPolicyValidatorProtocolSpy()
    useCase = HasBiometricAuthUseCase(localAuthenticationPolicyValidator: spyPolicyValidator, context: spyContext)
  }

  func testBiometricPolicyValidated() {
    spyPolicyValidator.validatePolicyContextClosure = { _, _ in }

    let result = useCase.execute()
    XCTAssertTrue(result)
    XCTAssertTrue(spyPolicyValidator.validatePolicyContextCalled)
    XCTAssertEqual(spyPolicyValidator.validatePolicyContextReceivedArguments?.policy, .deviceOwnerAuthenticationWithBiometrics)
  }

  func testBiometricPolicyError() {
    spyPolicyValidator.validatePolicyContextThrowableError = TestingError.error

    let result = useCase.execute()
    XCTAssertFalse(result)
    XCTAssertTrue(spyPolicyValidator.validatePolicyContextCalled)
    XCTAssertEqual(spyPolicyValidator.validatePolicyContextReceivedArguments?.policy, .deviceOwnerAuthenticationWithBiometrics)
  }

  // MARK: Private

  // swiftlint:disable all
  private var spyPolicyValidator: LocalAuthenticationPolicyValidatorProtocolSpy!
  private var spyContext: LAContextProtocolSpy!
  private var useCase: HasBiometricAuthUseCase!
  // swiftlint:enable all

}
