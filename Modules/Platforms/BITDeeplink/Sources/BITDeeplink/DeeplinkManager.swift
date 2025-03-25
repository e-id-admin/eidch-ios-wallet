import Foundation

public class DeeplinkManager<T: DeeplinkRoute> {

  // MARK: Lifecycle

  public init(allowedRoutes: [T]) {
    routes = allowedRoutes
  }

  // MARK: Public

  public func dispatch(_ url: URL, resolvingAgainstBaseURL: Bool = true) throws -> [T] {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: resolvingAgainstBaseURL) else { throw DeeplinkError.invalidUrl }
    let matchedRoutes = routes.filter {
      guard let scheme = components.scheme else { return false }
      return $0.schemes.contains(scheme) && components.host == $0.action
    }
    guard !matchedRoutes.isEmpty else { throw DeeplinkError.routeNotFound }
    return matchedRoutes.compactMap { $0 as? T }
  }

  public func dispatchFirst(_ url: URL, resolvingAgainstBaseURL: Bool = true) throws -> T {
    let routes: [T] = try dispatch(url, resolvingAgainstBaseURL: resolvingAgainstBaseURL)
    guard let route = routes.first else { throw DeeplinkError.routeNotFound }
    return route
  }

  // MARK: Internal

  let routes: [any DeeplinkRoute]

}
