import Foundation
import XCTest
@testable import BITTheming

class SecurityIntroductionScreen: InformationScreen {

  // MARK: Lifecycle

  override init(app: XCUIApplication) {
    backButton = app.buttons["Back"]
    tertiaryText = app.staticTexts[InformationView.AccessibilityIdentifier.tertiaryText.rawValue]
    super.init(app: app)
  }

  // MARK: Internal

  let backButton: XCUIElement
  let tertiaryText: XCUIElement
  let expectedImageLabel = "shield person"

  override func assert() {
    super.assert()
    XCTAssertEqual(getImagelabel(), expectedImageLabel)
    XCTAssertTrue(secondaryText.exists)
    XCTAssertTrue(tertiaryText.exists)
  }

}