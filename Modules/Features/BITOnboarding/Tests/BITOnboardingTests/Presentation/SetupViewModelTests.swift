import Foundation
import Spyable
import SwiftUI
import XCTest

@testable import BITAppAuth
@testable import BITOnboarding

final class SetupViewModelTests: XCTestCase {

  // MARK: Internal

  @AppStorage("rootOnboardingIsEnabled") var isOnboardingEnabled: Bool = true

  @MainActor
  override func setUp() {
    super.setUp()

    registerPinCodeUseCase = RegisterPinCodeUseCaseProtocolSpy()
    isOnboardingEnabled = true
    router = MockOnboardingInternalRoutes()
    viewModel = SetupViewModel(
      router: router,
      registerPinCodeUseCase: registerPinCodeUseCase)
  }

  @MainActor
  func testRunSetup() async {
    router.context.pincode = "123456"

    await viewModel.run()

    XCTAssertTrue(registerPinCodeUseCase.executePinCodeCalled)
    XCTAssertEqual(registerPinCodeUseCase.executePinCodeCallsCount, 1)
    XCTAssertTrue(router.completedCalled)
    XCTAssertFalse(viewModel.isOnboardingEnabled)
  }

  @MainActor
  func testRunSetupWithoutPin() async {
    router.context.pincode = nil

    await viewModel.run()

    XCTAssertFalse(registerPinCodeUseCase.executePinCodeCalled)
    XCTAssertFalse(router.completedCalled)
    XCTAssertTrue(router.setupErrorCalled)
    XCTAssertTrue(viewModel.isOnboardingEnabled)
  }

  @MainActor
  func testRunSetupError() async {
    registerPinCodeUseCase.executePinCodeThrowableError = NSError()
    router.context.pincode = "123456"

    await viewModel.run()

    XCTAssertTrue(registerPinCodeUseCase.executePinCodeCalled)
    XCTAssertEqual(registerPinCodeUseCase.executePinCodeCallsCount, 1)
    XCTAssertFalse(router.completedCalled)
    XCTAssertTrue(router.setupErrorCalled)
    XCTAssertTrue(viewModel.isOnboardingEnabled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: SetupViewModel!
  private var router: MockOnboardingInternalRoutes!
  private var registerPinCodeUseCase: RegisterPinCodeUseCaseProtocolSpy!
  // swiftlint:enable all

}
