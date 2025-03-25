import XCTest
@testable import BITPresentation

class PresentationRequestResultStateViewScreen: Screen {

  // MARK: Lifecycle

  init(app: XCUIApplication) {
    self.app = app
    closeButton = app.buttons[PresentationRequestResultStateView.AccessibilityIdentifier.closeButton.rawValue]
  }

  // MARK: Internal

  let app: XCUIApplication
  let closeButton: XCUIElement

  func assertDisplayed() {
    XCTAssert(closeButton.exists)
  }
}
