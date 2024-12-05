import Foundation

// MARK: - Analytics

public typealias AnalyticsProtocol = Loggable & PrivacySettable & ProviderRegisterable

// MARK: - Analytics

final class Analytics: AnalyticsProtocol {

  private(set) public var providers: [AnalyticsProviderProtocol] = []

  public var isAnalyticsEnabled: Bool {
    providers.contains { $0.isAnalyticsEnabled }
  }

  public func log(_ event: AnalyticsEventProtocol) {
    for provider in providers {
      provider.log(event)
    }
  }

  public func log(_ errorEvent: AnalyticsErrorEventProtocol) {
    for provider in providers {
      provider.log(errorEvent)
    }
  }

  public func log(_ error: Error) {
    for provider in providers {
      provider.log(error)
    }
  }

  public func register(_ provider: any AnalyticsProviderProtocol) {
    guard !providers.contains(where: { type(of: provider).identifier == type(of: $0).identifier }) else { return }
    providers.append(provider)
  }

  public func applyUserPrivacyPolicy(_ isEnabled: Bool) async {
    for provider in providers {
      await provider.applyUserPrivacyPolicy(isEnabled)
    }
  }

}
