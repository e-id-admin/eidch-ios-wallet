import Foundation
import XCTest

class EnterPinScreen {

  // MARK: Lifecycle

  init(app: XCUIApplication) {
    self.app = app
    pinField = app.otherElements["Pincode contains 0 entries out of 6"]
    backButton = app.buttons["Back"]
    titleText = app.staticTexts["Enter code"]
  }

  // MARK: Internal

  let app: XCUIApplication
  let pinField: XCUIElement
  let backButton: XCUIElement
  let titleText: XCUIElement

  func enterPin(pin: String) {
    if pin.count <= 6 {
      for n in pin {
        app.keys[String(n)].tap()
      }
    }
  }
}
