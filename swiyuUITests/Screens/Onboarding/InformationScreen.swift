import Foundation
import XCTest
@testable import BITTheming

class InformationScreen: Screen {

  // MARK: Lifecycle

  init(app: XCUIApplication) {
    self.app = app
    primaryButton = app.buttons[InformationView<DefaultInformationContentView, DefaultInformationFooterView>.AccessibilityIdentifier.footer.rawValue]
    secondaryButton = app.buttons[DefaultInformationFooterView.AccessibilityIdentifier.secondaryButton.rawValue]
    image = app.images[InformationView<DefaultInformationContentView, DefaultInformationFooterView>.AccessibilityIdentifier.image.rawValue]
    if XCUIDevice.shared.orientation.isLandscape {
      primaryText = app.staticTexts[InformationView<DefaultInformationContentView, DefaultInformationFooterView>.AccessibilityIdentifier.content.rawValue]
      secondaryText = app.staticTexts[InformationView<DefaultInformationContentView, DefaultInformationFooterView>.AccessibilityIdentifier.content.rawValue]
    }
    else {
      primaryText = app.staticTexts[DefaultInformationContentView.AccessibilityIdentifier.primaryText.rawValue]
      secondaryText = app.staticTexts[DefaultInformationContentView.AccessibilityIdentifier.secondaryText.rawValue]
    }
  }

  // MARK: Internal

  let app: XCUIApplication
  let primaryButton: XCUIElement
  let secondaryButton: XCUIElement
  let image: XCUIElement
  let primaryText: XCUIElement
  let secondaryText: XCUIElement

  func getImagelabel() -> String {
    app.descendants(matching: .image).matching(identifier: InformationView<DefaultInformationContentView, DefaultInformationFooterView>.AccessibilityIdentifier.image.rawValue).allElementsBoundByIndex[1].label
  }

  func assertDisplayed() {
    XCTAssertTrue(image.waitForExistence(timeout: 3))
    XCTAssertTrue(primaryText.exists)
  }

}
