import Foundation
import XCTest

class PinCodeInformationScreen: InformationScreen {

  // MARK: Lifecycle

  override init(app: XCUIApplication) {
    backButton = app.buttons["Back"]
    super.init(app: app)
  }

  // MARK: Internal

  let backButton: XCUIElement
  let expectedImageLabel = "lock"

  override func assert() {
    super.assert()
    XCTAssertEqual(getImagelabel(), expectedImageLabel)
    XCTAssertTrue(secondaryText.exists)
  }

}
