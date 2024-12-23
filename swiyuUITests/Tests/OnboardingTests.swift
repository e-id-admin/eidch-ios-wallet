import Foundation
import XCTest
@testable import BITOnboarding
@testable import swiyu

// MARK: - OnboardingTests

final class OnboardingTests: XCTestCase {

  var app: XCUIApplication = .init()

  override func setUp() {
    super.setUp()
    app = XCUIApplication()
    app.launch()
  }

  override func tearDown() {
    let screenshot = XCUIScreen.main.screenshot()
    let attachment = XCTAttachment(screenshot: screenshot)
    add(attachment)
  }

  override func tearDownWithError() throws {
    let screenshot = XCUIScreen.main.screenshot()
    let attachment = XCTAttachment(screenshot: screenshot)
    add(attachment)
  }

  func testAppOpensOnStartScreen() {
    let welcomeIntroductionScreen = WelcomeIntroductionScreen(app: app)
    welcomeIntroductionScreen.assert()
  }

  func testBasicNavigation() {
    let welcomeIntroductionScreen = WelcomeIntroductionScreen(app: app)
    welcomeIntroductionScreen.assert()
    welcomeIntroductionScreen.continueButton.tap()

    let credentialIntroductionScreen = CredentialIntroductionScreen(app: app)
    credentialIntroductionScreen.assert()
    credentialIntroductionScreen.continueButton.tap()

    let securityIntroductionScreen = SecurityIntroductionScreen(app: app)
    securityIntroductionScreen.assert()
    securityIntroductionScreen.continueButton.tap()

    let privacyPermissionScreen = PrivacyPermissionScreen(app: app)
    privacyPermissionScreen.assert()
  }

  func testBacknavigation() {
    let welcomeIntroductionScreen = WelcomeIntroductionScreen(app: app)
    welcomeIntroductionScreen.assert()
    welcomeIntroductionScreen.continueButton.tap()

    let credentialIntroductionScreen = CredentialIntroductionScreen(app: app)
    credentialIntroductionScreen.assert()
    credentialIntroductionScreen.continueButton.tap()

    let securityIntroductionScreen = SecurityIntroductionScreen(app: app)
    securityIntroductionScreen.assert()
    securityIntroductionScreen.continueButton.tap()

    let privacyPermissionScreen = PrivacyPermissionScreen(app: app)
    privacyPermissionScreen.assert()
    privacyPermissionScreen.acceptButton.tap()

    let pinCodeInformationScreen = PinCodeInformationScreen(app: app)
    pinCodeInformationScreen.assert()
    pinCodeInformationScreen.backButton.tap()

    privacyPermissionScreen.assert()
    privacyPermissionScreen.backButton.tap()

    securityIntroductionScreen.assert()
    securityIntroductionScreen.backButton.tap()

    credentialIntroductionScreen.assert()
    credentialIntroductionScreen.backButton.tap()

    welcomeIntroductionScreen.assert()
  }

  func testPincodeEntry() {
    let welcomeIntroductionScreen = WelcomeIntroductionScreen(app: app)
    welcomeIntroductionScreen.assert()
    welcomeIntroductionScreen.continueButton.tap()

    let credentialIntroductionScreen = CredentialIntroductionScreen(app: app)
    credentialIntroductionScreen.assert()
    credentialIntroductionScreen.continueButton.tap()

    let securityIntroductionScreen = SecurityIntroductionScreen(app: app)
    securityIntroductionScreen.assert()
    securityIntroductionScreen.continueButton.tap()

    let privacyPermissionScreen = PrivacyPermissionScreen(app: app)
    privacyPermissionScreen.assert()
    privacyPermissionScreen.acceptButton.tap()

    let pinCodeInformationScreen = PinCodeInformationScreen(app: app)
    pinCodeInformationScreen.assert()
    pinCodeInformationScreen.continueButton.tap()

    let enterPinScreen = EnterPinScreen(app: app)
    XCTAssertTrue(enterPinScreen.pinField.waitForExistence(timeout: 1))

    enterPinScreen.enterPin(pin: "123456")
    XCTAssertTrue(enterPinScreen.pinField.waitForExistence(timeout: 1))
    enterPinScreen.enterPin(pin: "123456")

  }

}
