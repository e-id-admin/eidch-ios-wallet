import XCTest

final class PresentationTests: XCTestCase {

  var app = XCUIApplication()

  override func setUp() {
    super.setUp()
    app = XCUIApplication()
    app.launchArguments.append("-disable-onboarding")
    app.launchArguments.append("-presentation")
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

    let presentationScreen = PresentationRequestReviewScreen(app: app)
    presentationScreen.assertDisplayed()
    presentationScreen.acceptButton.tap()

    let presentationResultScreen = PresentationRequestResultStateViewScreen(app: app)
    presentationResultScreen.closeButton.tap()
    homeScreen.assertDisplayed()
  }
}
