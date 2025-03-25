import Foundation
import XCTest
@testable import BITOnboarding

class BiometricsScreen: Screen {

  // MARK: Lifecycle

  init(app: XCUIApplication) {
    self.app = app
    skipButton = app.buttons[BiometricView.AccessibilityIdentifier.skipButton.rawValue]
    settingsButton = app.buttons[BiometricView.AccessibilityIdentifier.settingsButton.rawValue]
    backButton = app.buttons["Back"]
    primaryText = app.staticTexts[BiometricView.AccessibilityIdentifier.primaryText.rawValue]
    secondaryText = app.staticTexts[BiometricView.AccessibilityIdentifier.secondaryText.rawValue]
  }

  // MARK: Internal

  let app: XCUIApplication
  let skipButton: XCUIElement
  let settingsButton: XCUIElement
  let backButton: XCUIElement
  let primaryText: XCUIElement
  let secondaryText: XCUIElement

  func assertDisplayed() {
    XCTAssertTrue(primaryText.exists)
  }

}
