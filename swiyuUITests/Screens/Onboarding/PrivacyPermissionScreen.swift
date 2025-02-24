import Foundation
import XCTest
@testable import BITOnboarding

class PrivacyPermissionScreen: Screen {

  // MARK: Lifecycle

  init(app: XCUIApplication) {
    self.app = app
    acceptButton = app.buttons[PrivacyPermissionView.AccessibilityIdentifier.acceptButton.rawValue]
    declineButton = app.buttons[PrivacyPermissionView.AccessibilityIdentifier.declineButton.rawValue]
    backButton = app.buttons["Back"]
    image = app.images[PrivacyPermissionView.AccessibilityIdentifier.image.rawValue]
    primaryText = app.staticTexts[PrivacyPermissionView.AccessibilityIdentifier.primaryText.rawValue]
    secondaryText = app.staticTexts[PrivacyPermissionView.AccessibilityIdentifier.secondaryText.rawValue]
    dataProtectionLink = app.links[PrivacyPermissionView.AccessibilityIdentifier.privacyLink.rawValue]
  }

  // MARK: Internal

  let app: XCUIApplication
  let acceptButton: XCUIElement
  let declineButton: XCUIElement
  let backButton: XCUIElement
  let image: XCUIElement
  let primaryText: XCUIElement
  let secondaryText: XCUIElement
  let dataProtectionLink: XCUIElement
  let expectedImageLabel = "verify cross"

  func assertDisplayed() {
    XCTAssertTrue(primaryText.exists)
  }

  func getImagelabel() -> String {
    app.descendants(matching: .image).matching(identifier: PrivacyPermissionView.AccessibilityIdentifier.image.rawValue).allElementsBoundByIndex[0].label
  }

  func navigateFromAppStartToScreen() {
    let credentialIntroduction = CredentialIntroductionScreen(app: app)
    credentialIntroduction.navigateFromAppStartToScreen()
    credentialIntroduction.primaryButton.tap()
    assertDisplayed()
  }

}
