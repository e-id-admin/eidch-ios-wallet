import Alamofire
import XCTest
@testable import BITNetworking

class WildcardServerTrustManagerTests: XCTestCase {

  func testServerTrustEvaluator_forExactHostMatch() throws {
    let exactEvaluator = DefaultTrustEvaluator()
    let evaluators: [String: ServerTrustEvaluating] = [
      "example.com": exactEvaluator,
    ]
    let manager = WildcardServerTrustManager(evaluators: evaluators)

    let returnedEvaluator = try manager.serverTrustEvaluator(forHost: "example.com")
    XCTAssertNotNil(returnedEvaluator, "Evaluator should not be nil for an exact match.")
  }

  func testServerTrustEvaluator_forDeeperHostMatch() throws {
    let exactEvaluator = DefaultTrustEvaluator()
    let evaluators: [String: ServerTrustEvaluating] = [
      "example.com": exactEvaluator,
    ]
    let manager = WildcardServerTrustManager(evaluators: evaluators)

    let returnedEvaluator = try manager.serverTrustEvaluator(forHost: "api.example.com")
    XCTAssertNotNil(returnedEvaluator, "Evaluator should not be nil for an exact match.")
  }

  func testServerTrustEvaluator_forWildcardHostMatch() throws {
    let wildcardEvaluator = DefaultTrustEvaluator()
    let evaluators: [String: ServerTrustEvaluating] = [
      "*.wildcard.com": wildcardEvaluator,
    ]
    let manager = WildcardServerTrustManager(evaluators: evaluators)

    let subdomainEvaluator = try manager.serverTrustEvaluator(forHost: "api.wildcard.com")
    XCTAssertNotNil(subdomainEvaluator, "Evaluator should not be nil for a matching wildcard subdomain.")
  }

  func testServerTrustEvaluator_forNoMatch() throws {
    let exactEvaluator = DefaultTrustEvaluator()
    let wildcardEvaluator = DefaultTrustEvaluator()
    let evaluators: [String: ServerTrustEvaluating] = [
      "example.com": exactEvaluator,
      "*.wildcard.com": wildcardEvaluator,
    ]
    let manager = WildcardServerTrustManager(evaluators: evaluators)

    let noMatchEvaluator = try manager.serverTrustEvaluator(forHost: "no-match.com")
    XCTAssertNil(noMatchEvaluator, "Should return nil when no evaluators match the given host.")
    let rootDomainEvaluator = try manager.serverTrustEvaluator(forHost: "wildcard.com")
    XCTAssertNil(rootDomainEvaluator, "Evaluator should not match the root for a wildcard pattern.")
  }

  func testServerTrustEvaluator_forMultiplePatterns() throws {
    let exactEvaluator = DefaultTrustEvaluator()
    let wildcardEvaluator = DefaultTrustEvaluator()
    let anotherWildcardEvaluator = DefaultTrustEvaluator()

    let evaluators: [String: ServerTrustEvaluating] = [
      "example.com": exactEvaluator,
      "*.test.com": wildcardEvaluator,
      "*.api.test.com": anotherWildcardEvaluator,
    ]
    let manager = WildcardServerTrustManager(evaluators: evaluators)

    let exactMatchEvaluator = try manager.serverTrustEvaluator(forHost: "example.com")
    XCTAssertNotNil(exactMatchEvaluator, "Evaluator should not be nil for an exact match.")
    let wildcardMatchEvaluator = try manager.serverTrustEvaluator(forHost: "sub.test.com")
    XCTAssertNotNil(wildcardMatchEvaluator, "Evaluator should not be nil for a wildcard match.")
    let deeperWildcardMatchEvaluator = try manager.serverTrustEvaluator(forHost: "v1.api.test.com")
    XCTAssertNotNil(deeperWildcardMatchEvaluator, "Evaluator should not be nil for a wildcard match.")
  }
}
