import Factory
import Foundation
import XCTest
@testable import BITAppAuth
@testable import swiyu

final class SplashScreenSceneTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    super.setUp()

    hasDevicePinUseCase = HasDevicePinUseCaseProtocolSpy()
    sceneManagerDelegate = SceneManagerDelegateSpy()

    Container.shared.hasDevicePinUseCase.register { self.hasDevicePinUseCase }

    scene = SplashScreenScene()
    scene.delegate = sceneManagerDelegate
  }

  @MainActor
  func testHappyPath() {
    hasDevicePinUseCase.executeReturnValue = true
    UserDefaults.standard.setValue(false, forKey: "rootOnboardingIsEnabled")

    scene.didCompleteSplashScreen()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == AppScene.self }))
  }

  @MainActor
  func testNoDevicePinCode() {
    hasDevicePinUseCase.executeReturnValue = false

    scene.didCompleteSplashScreen()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == NoDevicePinCodeScene.self }))
  }

  @MainActor
  func testOnboardingEnabled() {
    hasDevicePinUseCase.executeReturnValue = true
    UserDefaults.standard.setValue(true, forKey: "rootOnboardingIsEnabled")

    scene.didCompleteSplashScreen()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == OnboardingScene.self }))
  }

  // MARK: Private

  // swiftlint:disable all
  private var scene: SplashScreenScene!
  private var sceneManagerDelegate: SceneManagerDelegateSpy!
  private var hasDevicePinUseCase: HasDevicePinUseCaseProtocolSpy!
  // swiftlint:enable all

}
