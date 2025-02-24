import XCTest
@testable import BITLocalAuthentication

final class LocalAuthenticationPolicyValidatorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    spyContext = LAContextProtocolSpy()
    validator = LocalAuthenticationPolicyValidator()
  }

  func testValidatePolicySuccess() throws {
    let policy = LocalAuthenticationPolicy.deviceOwnerAuthenticationWithBiometrics
    spyContext.canEvaluatePolicyErrorReturnValue = true

    try validator.validatePolicy(policy, context: spyContext)
    XCTAssertTrue(spyContext.canEvaluatePolicyErrorCalled)
    XCTAssertEqual(policy, spyContext.canEvaluatePolicyErrorReceivedArguments?.policy)
  }

  func testValidatePolicyFailed() throws {
    let policy = LocalAuthenticationPolicy.deviceOwnerAuthenticationWithBiometrics
    spyContext.canEvaluatePolicyErrorReturnValue = false

    do {
      try validator.validatePolicy(policy, context: spyContext)
      XCTFail("An error was expected")
    } catch LocalAuthenticationPolicyError.invalidPolicy {
      XCTAssertTrue(spyContext.canEvaluatePolicyErrorCalled)
      XCTAssertEqual(policy, spyContext.canEvaluatePolicyErrorReceivedArguments?.policy)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var spyContext: LAContextProtocolSpy!
  private var spyLocalAuthenticationPolicyValidator: LocalAuthenticationPolicyValidatorProtocolSpy!
  private var validator: LocalAuthenticationPolicyValidator!
  // swiftlint:enable all

}
