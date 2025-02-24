import BITNetworking
import Foundation
import XCTest
@testable import BITJWT

final class DidResolverRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = DidResolverRepository()

    NetworkContainer.shared.reset()
    NetworkContainer.shared.stubClosure.register {
      { _ in .immediate }
    }
  }

  func testFetchDidLog_success() async throws {
    guard let mockURL = URL(string: strURL) else { fatalError("url building") }
    let testString = "[\"test\"]"
    let testData = try testString.asData()
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, testData)
    }

    let didLog = try await repository.fetchDidLog(from: mockURL)

    XCTAssertEqual(didLog, testString)
  }

  func testFetchDidLog_failure() async throws {
    guard let mockURL = URL(string: strURL) else { fatalError("url building") }

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, Data())
    }

    do {
      _ = try await repository.fetchDidLog(from: mockURL)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  // MARK: Private

  private let strURL = "some://url"
  private var repository = DidResolverRepository()

}
