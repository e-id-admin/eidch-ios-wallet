import Foundation
import XCTest

class PrivacyPermissionScreen: Screen {

  // MARK: Lifecycle

  init(app: XCUIApplication) {
    self.app = app
    acceptButton = app.buttons["Accept"]
    declineButton = app.buttons["Decline"]
    backButton = app.buttons["Back"]
    image = app.images["verify cross"]
    primaryText = app.staticTexts["Help us to improve"]
    secondaryText = app.staticTexts["Allow anonymized usage data to be shared with our development team."]
    tertiaryText = app.staticTexts["Data protection and security"]
    dataProtectionLink = app.links["Data protection and security"]
  }

  // MARK: Internal

  let app: XCUIApplication
  let acceptButton: XCUIElement
  let declineButton: XCUIElement
  let backButton: XCUIElement
  let image: XCUIElement
  let primaryText: XCUIElement
  let secondaryText: XCUIElement
  let tertiaryText: XCUIElement
  let dataProtectionLink: XCUIElement
  let expectedImageLabel = "verify cross"

  func assert() {
    XCTAssertTrue(image.waitForExistence(timeout: 3))
    XCTAssertTrue(primaryText.exists)
    XCTAssertEqual(image.label, expectedImageLabel)
    XCTAssertTrue(secondaryText.exists)
    XCTAssertTrue(tertiaryText.exists)
  }

}
