import Foundation
import XCTest
@testable import BITTheming

class InformationScreen: Screen {

  // MARK: Lifecycle

  init(app: XCUIApplication) {
    self.app = app
    continueButton = app.buttons[InformationView.AccessibilityIdentifier.continueButton.rawValue]
    image = app.images[InformationView.AccessibilityIdentifier.image.rawValue]
    primaryText = app.staticTexts[InformationView.AccessibilityIdentifier.primaryText.rawValue]
    secondaryText = app.staticTexts[InformationView.AccessibilityIdentifier.secondaryText.rawValue]
  }

  // MARK: Internal

  let app: XCUIApplication
  let continueButton: XCUIElement
  let image: XCUIElement
  let primaryText: XCUIElement
  let secondaryText: XCUIElement

  func getImagelabel() -> String {
    app.descendants(matching: .image).matching(identifier: InformationView.AccessibilityIdentifier.image.rawValue).allElementsBoundByIndex[1].label
  }

  func assert() {
    XCTAssertTrue(image.waitForExistence(timeout: 3))
    XCTAssertTrue(primaryText.exists)
  }

}
