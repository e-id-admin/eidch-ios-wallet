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

  override func assertDisplayed() {
    super.assertDisplayed()
    XCTAssertEqual(getImagelabel(), expectedImageLabel)
    XCTAssertTrue(secondaryText.exists)
  }

  func navigateFromAppStartToScreen() {
    let privacyPermission = PrivacyPermissionScreen(app: app)
    privacyPermission.navigateFromAppStartToScreen()
    privacyPermission.acceptButton.tap()
    assertDisplayed()
  }

}
