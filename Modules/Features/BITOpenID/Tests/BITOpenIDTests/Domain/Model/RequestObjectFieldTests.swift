import Foundation
import XCTest

@testable import BITOpenID
@testable import BITTestingCore

final class RequestObjectFieldTests: XCTestCase {
  func testRequestObjectFields() throws {
    let field = Field(path: ["$.credentialSubject.lastName"])
    let value = ["John", "Joseph", "James"]

    let values = field.matching(valuesIn: value)
    XCTAssertEqual(values.count, 3)
  }
}
