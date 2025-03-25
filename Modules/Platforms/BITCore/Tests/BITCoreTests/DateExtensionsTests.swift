import Foundation
import XCTest
@testable import BITCore

final class DateExtensionsTests: XCTestCase {

  // MARK: Internal

  func testNumberOfDaysSince_fromMidnightToNextDayAfterMidnight_Returns1() throws {
    let midnightDate = Calendar.current.startOfDay(for: Date())
    let nextMidnightDate = midnightDate.advanced(by: Self.secondsPerHour * 24 + 1)
    let days = nextMidnightDate.numberOfDaysSince(midnightDate)

    XCTAssertEqual(days, 1)
  }

  func testIsWithinNext24Hours_nextSecond_ReturnsTrue() throws {
    let date = Date().advanced(by: 1)
    XCTAssertTrue(date.isWithinNext24Hours)
  }

  func testIsWithinNext24Hours_justBefore24Hours_ReturnsTrue() throws {
    let date = Date().advanced(by: Self.secondsPerHour * 24 - 1)
    XCTAssertTrue(date.isWithinNext24Hours)
  }

  func testIsWithinNext24Hours_justAfter24Hours_ReturnsFalse() throws {
    let date = Date().advanced(by: Self.secondsPerHour * 24 + 1)
    XCTAssertFalse(date.isWithinNext24Hours)
  }

  func testIsWithinNext24Hours_48HoursLater_ReturnsFalse() throws {
    let date = Date().advanced(by: Self.secondsPerHour * 48)
    XCTAssertFalse(date.isWithinNext24Hours)
  }

  func testIsWithinNext24Hours_InAYear_ReturnsFalse() throws {
    let date = Date().advanced(by: Self.secondsPerHour * 24 * 365)
    XCTAssertFalse(date.isWithinNext24Hours)
  }

  func testIsWithinNext24Hours_now_ReturnsFalse() throws {
    let date = Date()
    XCTAssertFalse(date.isWithinNext24Hours)
  }

  func testIsWithinNext24Hours_24HoursAgo_ReturnsFalse() throws {
    let date = Date().advanced(by: -Self.secondsPerHour * 24)
    XCTAssertFalse(date.isWithinNext24Hours)
  }

  func testIsWithinNext24Hours_aYearAgo_ReturnsFalse() throws {
    let date = Date().advanced(by: -Self.secondsPerHour * 24 * 365)
    XCTAssertFalse(date.isWithinNext24Hours)
  }

  // MARK: Private

  private static let secondsPerHour: Double = 60 * 60

}
