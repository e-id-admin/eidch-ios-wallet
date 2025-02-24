import Foundation
import XCTest
@testable import swiyu

// MARK: - ReceiveTests

final class ReceiveTests: XCTestCase {

  var app = XCUIApplication()

  override func setUp() {
    super.setUp()
    app = XCUIApplication()
    app.launchArguments.append("-disable-onboarding")
    app.launchArguments.append("-disable-delays")
    app.launchArguments.append("-ui-tests")
    app.launch()
  }

  override func tearDown() {
    let screenshot = XCUIScreen.main.screenshot()
    let attachment = XCTAttachment(screenshot: screenshot)
    add(attachment)
  }

  override func tearDownWithError() throws {
    let screenshot = XCUIScreen.main.screenshot()
    let attachment = XCTAttachment(screenshot: screenshot)
    add(attachment)
  }

  func testBasicNavigation() {
    let loginScreen = LoginScreen(app: app)
    loginScreen.login()

    let homeScreen = HomeScreen(app: app)
    homeScreen.assertDisplayed()
    homeScreen.scanButton.tap()

    let credentialOfferScreen = CredentialOfferScreen(app: app)
    credentialOfferScreen.assertDisplayed()
    credentialOfferScreen.acceptButton.tap()
    homeScreen.assertDisplayed()
  }
}
