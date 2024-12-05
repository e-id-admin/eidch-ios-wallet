import Foundation
import LocalAuthentication
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITLocalAuthentication
@testable import BITTestingCore
@testable import BITVault

// MARK: - ValidatePinCodeUseCaseTests

final class GetBiometricTypeUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    localAuthPolicyValidator = LocalAuthenticationPolicyValidatorProtocolSpy()
    context = LAContextProtocolSpy()
    useCase = GetBiometricTypeUseCase(validator: localAuthPolicyValidator, context: context)
  }

  func test_validatePolicy() {
    context.biometryType = .faceID
    let _ = useCase.execute()
    XCTAssertEqual(localAuthPolicyValidator.validatePolicyContextReceivedArguments?.policy, .deviceOwnerAuthenticationWithBiometrics)
  }

  func test_biometricType_faceID() {
    context.biometryType = .faceID
    let result = useCase.execute()
    XCTAssertEqual(result, .faceID)
  }

  func test_biometricType_touchID() {
    context.biometryType = .touchID
    let result = useCase.execute()
    XCTAssertEqual(result, .touchID)
  }

  func test_biometricType_somethingElse() {
    context.biometryType = .none
    let result = useCase.execute()
    XCTAssertEqual(result, .none)
  }

  func test_biometricTypeIsNoneWhenError() {
    localAuthPolicyValidator.validatePolicyContextThrowableError = TestingError.error
    let result = useCase.execute()
    XCTAssertEqual(result, .none)
  }

  // MARK: Private

  // swiftlint:disable all
  private var context: LAContextProtocolSpy!
  private var localAuthPolicyValidator: LocalAuthenticationPolicyValidatorProtocolSpy!
  private var useCase: GetBiometricTypeUseCase!
  // swiftlint:enable all
}
