import XCTest
@testable import BITEIDRequest

final class EIDRequestEndpointTests: XCTestCase {

  func testSubmit() throws {
    let baseUrl = "https://eid.admin.ch"
    let expectedEndpoint = "eid/apply"

    guard let mockeIDRequestPayload: EIDRequestPayload = MRZData.Mock.array.first?.payload else {
      fatalError("Failed to create mock EIDRequestPayload")
    }

    let endpoint = URL(target: EIDRequestEndpoint.submit(payload: mockeIDRequestPayload))
    XCTAssertEqual("\(baseUrl)/\(expectedEndpoint)", endpoint.absoluteString)
  }

  func testGetStatus() throws {
    let baseUrl = "https://eid.admin.ch"
    let caseId = UUID().uuidString
    let expectedEndpoint = "eid/\(caseId)/state"

    let endpoint = URL(target: EIDRequestEndpoint.getStatus(caseId: caseId))
    XCTAssertEqual("\(baseUrl)/\(expectedEndpoint)", endpoint.absoluteString)
  }
}
