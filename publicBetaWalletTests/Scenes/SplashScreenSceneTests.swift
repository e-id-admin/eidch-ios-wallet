import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITSecurity
@testable import publicBetaWallet

final class SplashScreenSceneTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    super.setUp()

    sceneManagerDelegate = SceneManagerDelegateSpy()
    hasDevicePinUseCase = HasDevicePinUseCaseProtocolSpy()
    jailbreakDetector = JailbreakDetectorProtocolSpy()

    scene = SplashScreenScene(hasDevicePinUseCase: hasDevicePinUseCase, jailbreakDetector: jailbreakDetector)
    scene.delegate = sceneManagerDelegate
  }

  @MainActor
  func testHappyPath() {
    hasDevicePinUseCase.executeReturnValue = true
    jailbreakDetector.isDeviceJailbrokenReturnValue = false
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
    jailbreakDetector.isDeviceJailbrokenReturnValue = false

    scene.didCompleteSplashScreen()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == NoDevicePinCodeScene.self }))
  }

  @MainActor
  func testOnboardingEnabled() {
    hasDevicePinUseCase.executeReturnValue = true
    jailbreakDetector.isDeviceJailbrokenReturnValue = false
    UserDefaults.standard.setValue(true, forKey: "rootOnboardingIsEnabled")

    scene.didCompleteSplashScreen()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == OnboardingScene.self }))
  }

  @MainActor
  func testDeviceJailbreak() {
    hasDevicePinUseCase.executeReturnValue = true
    jailbreakDetector.isDeviceJailbrokenReturnValue = true
    UserDefaults.standard.setValue(true, forKey: "rootOnboardingIsEnabled")

    scene.didCompleteSplashScreen()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == JailbreakScene.self }))
  }

  // MARK: Private

  // swiftlint:disable all
  private var scene: SplashScreenScene!
  private var sceneManagerDelegate: SceneManagerDelegateSpy!
  private var hasDevicePinUseCase: HasDevicePinUseCaseProtocolSpy!
  private var jailbreakDetector: JailbreakDetectorProtocolSpy!
  // swiftlint:enable all

}
