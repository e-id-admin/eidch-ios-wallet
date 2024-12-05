public protocol ProviderRegisterable {
  var providers: [AnalyticsProviderProtocol] { get }
  func register(_ provider: any AnalyticsProviderProtocol)
}
