import Foundation
import XCTest
@testable import BITAppAuth
@testable import publicBetaWallet

final class AppSceneTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    super.setUp()

    sceneManagerDelegate = SceneManagerDelegateSpy()
    hasDevicePinUseCase = HasDevicePinUseCaseProtocolSpy()
    router = RootRouterMock()

    appScene = AppScene(hasDevicePinUseCase: hasDevicePinUseCase, router: router)
    appScene.delegate = sceneManagerDelegate
  }

  @MainActor
  func testHappyPath() {
    hasDevicePinUseCase.executeReturnValue = true
    appScene.willEnterForeground()

    XCTAssertFalse(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertTrue(router.didCallLogin)
  }

  @MainActor
  func testNoDevicePinCode() {
    hasDevicePinUseCase.executeReturnValue = false
    appScene.willEnterForeground()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == NoDevicePinCodeScene.self }))
    XCTAssertFalse(router.didCallLogin)
  }

  func onUserInctivityDetected() {
    hasDevicePinUseCase.executeReturnValue = true

    NotificationCenter.default.post(name: .userInactivityTimeout, object: nil)

    XCTAssertFalse(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertTrue(router.didCallLogin)
  }

  // MARK: Private

  // swiftlint:disable all
  private var appScene: AppScene!
  private var router: RootRouterMock!
  private var sceneManagerDelegate: SceneManagerDelegateSpy!
  private var hasDevicePinUseCase: HasDevicePinUseCaseProtocolSpy!
  // swiftlint:enable all

}
