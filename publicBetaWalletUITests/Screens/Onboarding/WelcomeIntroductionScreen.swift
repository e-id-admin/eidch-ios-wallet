import Foundation
import XCTest
@testable import BITTheming

class WelcomeIntroductionScreen: InformationScreen {

  // MARK: Lifecycle

  override init(app: XCUIApplication) {
    tertiaryText = app.staticTexts[InformationView.AccessibilityIdentifier.tertiaryText.rawValue]
    super.init(app: app)

  }

  // MARK: Internal

  let tertiaryText: XCUIElement
  let expectedImageLabel = "shield cross"

  override func assert() {
    super.assert()
    XCTAssertEqual(getImagelabel(), expectedImageLabel)
    XCTAssertTrue(secondaryText.exists)
    XCTAssertTrue(tertiaryText.exists)
  }

}
