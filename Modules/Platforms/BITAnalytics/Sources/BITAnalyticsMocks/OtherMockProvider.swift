import BITAnalytics
import Foundation

public final class OtherMockProvider: AnalyticsProviderProtocol {

  // MARK: Lifecycle

  required public init() {}

  // MARK: Public

  public var logCounter = 0

  public var isAnalyticsEnabled = true

  public func log(_ event: AnalyticsEventProtocol) {
    logCounter += 1
  }

  public func log(_ errorEvent: AnalyticsErrorEventProtocol) {
    logCounter += 1
  }

  public func log(_ error: Error) {
    logCounter += 1
  }

  public func applyUserPrivacyPolicy(_ isEnabled: Bool) async {
    isAnalyticsEnabled = isEnabled
  }
}
