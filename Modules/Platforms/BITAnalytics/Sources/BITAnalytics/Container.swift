import Factory
import Foundation

extension Container {

  public var analytics: Factory<AnalyticsProtocol> {
    self { Analytics() }.singleton
  }

}
