import Foundation
import XCTest
@testable import BITOnboarding
@testable import swiyu

// MARK: - OnboardingTests

final class OnboardingLandscapeTests: XCTestCase {

  var app = XCUIApplication()

  override func setUp() {
    super.setUp()
    app = XCUIApplication()
    app.launch()
    XCUIDevice.shared.orientation = .landscapeRight
    XCTAssertTrue(XCUIDevice.shared.orientation.isLandscape)
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

  func testAppOpensOnStartScreenLandscape() {
    let onboardingTests = OnboardingTests()
    onboardingTests.testAppOpensOnStartScreen()
  }

  func testBasicNavigationLandscape() {
    let onboardingTests = OnboardingTests()
    onboardingTests.testBasicNavigation()
  }

  func testBacknavigationLandscape() {
    let onboardingTests = OnboardingTests()
    onboardingTests.testBacknavigation()
  }

  func testDynatraceDeclineNavigationLandscape() {
    let onboardingTests = OnboardingTests()
    onboardingTests.testDynatraceDeclineNavigation()
  }

  func testDynatraceAcceptThenDeclineNavigation() {
    let onboardingTests = OnboardingTests()
    onboardingTests.testDynatraceAcceptThenDeclineNavigation()
  }

}
