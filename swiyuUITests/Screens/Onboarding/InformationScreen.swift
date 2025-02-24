import Foundation
import XCTest
@testable import BITTheming

class InformationScreen: Screen {

  // MARK: Lifecycle

  init(app: XCUIApplication) {
    self.app = app
    primaryButton = app.buttons[InformationView.AccessibilityIdentifier.primaryButton.rawValue]
    secondaryButton = app.buttons[InformationView.AccessibilityIdentifier.secondaryButton.rawValue]
    image = app.images[InformationView.AccessibilityIdentifier.image.rawValue]
    primaryText = app.staticTexts[InformationView.AccessibilityIdentifier.primaryText.rawValue]
    secondaryText = app.staticTexts[InformationView.AccessibilityIdentifier.secondaryText.rawValue]
  }

  // MARK: Internal

  let app: XCUIApplication
  let primaryButton: XCUIElement
  let secondaryButton: XCUIElement
  let image: XCUIElement
  let primaryText: XCUIElement
  let secondaryText: XCUIElement

  func getImagelabel() -> String {
    app.descendants(matching: .image).matching(identifier: InformationView.AccessibilityIdentifier.image.rawValue).allElementsBoundByIndex[1].label
  }

  func assertDisplayed() {
    XCTAssertTrue(image.waitForExistence(timeout: 3))
    XCTAssertTrue(primaryText.exists)
  }

}
