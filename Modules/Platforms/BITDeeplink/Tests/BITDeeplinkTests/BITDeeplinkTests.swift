import Foundation
import XCTest
@testable import BITDeeplink

// MARK: - RegisteredDeeplink

enum RegisteredDeeplink: DeeplinkRoute, CaseIterable {

  case detailPage
  case detailPageWithParameters
  case menu

  // MARK: Internal

  var scheme: String {
    switch self {
    case .detailPage,
         .detailPageWithParameters,
         .menu: deeplinkScheme
    }
  }

  var action: String {
    switch self {
    case .detailPage,
         .detailPageWithParameters: "detail-page"
    case .menu: "menu"
    }
  }

}

let deeplinkScheme = "deeplink-scheme"

// MARK: - DeeplinkTests

// swiftlint:disable force_unwrapping

final class DeeplinkTests: XCTestCase {
  func testGetMultipleMatchingRoutes() throws {
    let manager = DeeplinkManager(allowedRoutes: RegisteredDeeplink.allCases)
    XCTAssertEqual(manager.routes.count, RegisteredDeeplink.allCases.count)

    let deeplink = URL(string: "\(deeplinkScheme)://detail-page")!

    let routes = try manager.dispatch(deeplink)
    XCTAssertEqual(routes.count, 2)
  }

  func testDetailRoute() throws {
    let manager = DeeplinkManager(allowedRoutes: RegisteredDeeplink.allCases)
    XCTAssertEqual(manager.routes.count, RegisteredDeeplink.allCases.count)

    let deeplink = URL(string: "\(deeplinkScheme)://detail-page")!

    let route = try manager.dispatchFirst(deeplink)
    XCTAssertEqual(route, .detailPage)
  }

  func testMenuRoute() throws {
    let manager = DeeplinkManager(allowedRoutes: RegisteredDeeplink.allCases)
    XCTAssertEqual(manager.routes.count, RegisteredDeeplink.allCases.count)

    let deeplink = URL(string: "\(deeplinkScheme)://menu")!

    let route = try manager.dispatchFirst(deeplink)
    XCTAssertEqual(route, .menu)
  }

  func testRegisterOneRouteAccessAnother() throws {
    let manager = DeeplinkManager(allowedRoutes: [RegisteredDeeplink.detailPage])
    XCTAssertEqual(manager.routes.count, 1)

    let deeplink = URL(string: "\(deeplinkScheme)://menu")!

    do {
      let _ = try manager.dispatchFirst(deeplink)
      XCTFail("Expected a failure with a not found route.")
    } catch {
      XCTAssertEqual(error as? DeeplinkError, DeeplinkError.routeNotFound)
    }
  }

  func testRegisterOneRouteAccessItSuccessfully() throws {
    let manager = DeeplinkManager(allowedRoutes: [RegisteredDeeplink.detailPage])
    XCTAssertEqual(manager.routes.count, 1)

    let deeplink = URL(string: "\(deeplinkScheme)://detail-page")!

    let route = try manager.dispatchFirst(deeplink)
    XCTAssertEqual(route, .detailPage)
  }

  func testNotFoundRoute() throws {
    let manager = DeeplinkManager(allowedRoutes: RegisteredDeeplink.allCases)
    XCTAssertEqual(manager.routes.count, RegisteredDeeplink.allCases.count)

    let deeplink = URL(string: "test-not-found://route")!

    do {
      let _ = try manager.dispatchFirst(deeplink)
      XCTFail("Expected a failure with a not found route.")
    } catch {
      XCTAssertEqual(error as? DeeplinkError, DeeplinkError.routeNotFound)
    }
  }
}

// swiftlint:enable force_unwrapping
