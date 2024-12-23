import Factory
import XCTest
@testable import swiyu

final class UserInactivityRunnerTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    runner = UserInactivityRunner(timeoutInterval: 2)
  }

  override func tearDown() {
    if let observer = notificationObserver {
      NotificationCenter.default.removeObserver(observer)
    }
    runner = nil
    super.tearDown()
  }

  func testNotificationIsSentOnTimeout() {
    let expectation = expectation(description: "NotificationExpectation")

    notificationObserver = NotificationCenter.default.addObserver(forName: .userInactivityTimeout, object: nil, queue: nil) { _ in
      expectation.fulfill()
    }

    let event = UIEvent()
    runner.sendEvent(event)

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testEventResetsTimer() {
    let expectation = expectation(description: "NotificationExpectation")
    expectation.expectedFulfillmentCount = 1

    notificationObserver = NotificationCenter.default.addObserver(forName: .userInactivityTimeout, object: nil, queue: nil) { _ in
      expectation.fulfill()
    }

    runner.sendEvent(UIEvent())

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.runner.sendEvent(UIEvent())
    }

    waitForExpectations(timeout: 5, handler: nil)
  }

  // MARK: Private

  // swiftlint:disable all
  private var runner: UserInactivityRunner!
  private var notificationObserver: NSObjectProtocol!
  // swiftlint:enable all

}
