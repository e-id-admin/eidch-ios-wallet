import Foundation
import XCTest
@testable import BITTheming

class CredentialIntroductionScreen: InformationScreen {

  // MARK: Lifecycle

  override init(app: XCUIApplication) {
    backButton = app.buttons["Back"]
    tertiaryText = app.staticTexts[DefaultInformationContentView.AccessibilityIdentifier.tertiaryText.rawValue]
    super.init(app: app)
  }

  // MARK: Internal

  let backButton: XCUIElement
  let tertiaryText: XCUIElement
  let expectedImageLabel = "e-id"

  override func assertDisplayed() {
    super.assertDisplayed()
    XCTAssertEqual(getImagelabel(), expectedImageLabel)
    XCTAssertTrue(secondaryText.exists)
  }

  func navigateFromAppStartToScreen() {
    let securityIntroduction = SecurityIntroductionScreen(app: app)
    securityIntroduction.navigateFromAppStartToScreen()
    securityIntroduction.primaryButton.tap()
    assertDisplayed()
  }

}
