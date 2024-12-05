import Foundation

// MARK: - AnalyticsProviderProtocol

public protocol AnalyticsProviderProtocol: Loggable, PrivacySettable {
  init()
}

extension AnalyticsProviderProtocol {
  static var identifier: String {
    String(describing: self)
  }
}
