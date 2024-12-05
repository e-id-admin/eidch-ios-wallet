import Factory
import XCTest

@testable import BITAppAuth
@testable import BITTestingCore

final class NewPinCodeViewModelTests: XCTestCase {

  // MARK: Internal

  //swiftlint:disable all
  var router = ChangePinRouterMock()

  //swiftlint:enable all

  @MainActor
  override func setUp() {
    super.setUp()

    router = ChangePinRouterMock()
    router.context.uniquePassphrase = "123456".data(using: .utf8)

    validatePinCodeRuleUseCase = ValidatePinCodeRuleUseCaseProtocolSpy()

    Container.shared.validatePinCodeRuleUseCase.register { self.validatePinCodeRuleUseCase }
  }

  override func tearDown() {
    super.tearDown()
    Container.shared.reset()
  }

  @MainActor
  func testInitialState() {
    let viewModel = NewPinCodeViewModel(router: router)
    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertFalse(viewModel.isToastPresented)
    XCTAssertNil(viewModel.inputFieldMessage)
    XCTAssertEqual(viewModel.inputFieldState, .normal)
    XCTAssertNotNil(viewModel.router.context.uniquePassphrase)
    XCTAssertNotNil(viewModel.router.context.newPinCodeDelegate)
    XCTAssertNil(viewModel.router.context.newPinCode)
  }

  @MainActor
  func testPinCode_success() throws {
    let viewModel = NewPinCodeViewModel(router: router)

    viewModel.submit()

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertNil(viewModel.inputFieldMessage)
    XCTAssertEqual(viewModel.inputFieldState, .normal)

    XCTAssertTrue(router.confirmNewPinCodeCalled)
    XCTAssertEqual(router.context.newPinCode, viewModel.pinCode)
    XCTAssertTrue(validatePinCodeRuleUseCase.executeCalled)
  }

  @MainActor
  func testPinCode_error() throws {
    validatePinCodeRuleUseCase.executeThrowableError = PinCodeError.tooShort
    let viewModel = NewPinCodeViewModel(router: router)

    viewModel.submit()

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertNotNil(viewModel.inputFieldMessage)
    XCTAssertEqual(viewModel.inputFieldState, .error)

    XCTAssertNil(viewModel.router.context.newPinCode)
    XCTAssertFalse(router.confirmNewPinCodeCalled)
    XCTAssertTrue(validatePinCodeRuleUseCase.executeCalled)
  }

  @MainActor
  func testPinCode_didRequestValidation() throws {
    validatePinCodeRuleUseCase.executeThrowableError = PinCodeError.tooShort
    let viewModel = Container.shared.newPinCodeViewModel(router)

    viewModel.submit()

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertNotNil(viewModel.inputFieldMessage)
    XCTAssertEqual(viewModel.inputFieldState, .error)

    XCTAssertNil(viewModel.router.context.newPinCode)
    XCTAssertFalse(router.confirmNewPinCodeCalled)

    viewModel.pinCode = "1234"

    XCTAssertFalse(viewModel.pinCode.isEmpty)
    XCTAssertNotNil(viewModel.inputFieldMessage)
    XCTAssertEqual(viewModel.inputFieldState, .error)

    XCTAssertNil(viewModel.router.context.newPinCode)
    XCTAssertFalse(router.confirmNewPinCodeCalled)

    validatePinCodeRuleUseCase.executeThrowableError = nil

    viewModel.pinCode = "12345"

    XCTAssertFalse(viewModel.pinCode.isEmpty)
    XCTAssertNil(viewModel.inputFieldMessage)
    XCTAssertEqual(viewModel.inputFieldState, .normal)

    XCTAssertFalse(router.confirmNewPinCodeCalled)
    XCTAssertNil(router.context.newPinCode, viewModel.pinCode)
  }

  // MARK: Private

  // swiftlint:disable all
  private var validatePinCodeRuleUseCase: ValidatePinCodeRuleUseCaseProtocolSpy!
  // swiftlint:enable all
}
