import Factory
import Foundation

extension Container {

  public var deepLinkManager: Factory<DeeplinkManager<RootDeeplinkRoute>> {
    self { DeeplinkManager(allowedRoutes: RootDeeplinkRoute.allCases) }
  }
}
