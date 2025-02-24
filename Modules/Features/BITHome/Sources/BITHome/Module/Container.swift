import BITNavigation
import Factory
import SwiftUI

@MainActor
extension Container {

  public var homeModule: Factory<HomeModule> {
    self { HomeModule() }
  }

  public var homeViewModel: ParameterFactory<HomeRouterRoutes, HomeViewModel> {
    self { HomeViewModel(router: $0) }
  }

}

extension Container {

  public var homeRouter: Factory<Router<UIViewController> & HomeRouterRoutes> {
    self { HomeRouter() }
  }

}
