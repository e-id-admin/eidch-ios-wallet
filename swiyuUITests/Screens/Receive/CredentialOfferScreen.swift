import Foundation
import XCTest
@testable import BITInvitation

class CredentialOfferScreen: Screen {

  // MARK: Lifecycle

  init(app: XCUIApplication) {
    self.app = app
    acceptButton = app.buttons[CredentialOfferView.AccessibilityIdentifier.acceptButton.rawValue]
  }

  // MARK: Internal

  let app: XCUIApplication
  let acceptButton: XCUIElement

  func assertDisplayed() {
    XCTAssert(acceptButton.waitForExistence(timeout: 3))
  }

}
