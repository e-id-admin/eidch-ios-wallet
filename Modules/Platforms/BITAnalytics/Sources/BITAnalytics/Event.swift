import Foundation

// MARK: - AnalyticsEvent

public struct AnalyticsEvent {}

// MARK: - AnalyticsEventProtocol

public protocol AnalyticsEventProtocol {

  typealias Parameters = [String: Any]?

  func name(_ provider: AnalyticsProviderProtocol.Type) -> String
  func parameters(_ provider: AnalyticsProviderProtocol.Type) -> Parameters
}

extension AnalyticsEventProtocol {
  public func name(_ provider: any AnalyticsProviderProtocol.Type) -> String {
    String(describing: self)
  }

  public func parameters(_ provider: any AnalyticsProviderProtocol.Type) -> Parameters {
    nil
  }
}

// MARK: - AnalyticsErrorEventProtocol

public protocol AnalyticsErrorEventProtocol: AnalyticsEventProtocol {
  func name(_ error: CustomStringConvertible & Error, _ provider: AnalyticsProviderProtocol.Type) -> String
  func error() -> Error
}

extension AnalyticsErrorEventProtocol {
  public func name(_ error: CustomStringConvertible & Error, _ provider: AnalyticsProviderProtocol.Type) -> String {
    String(reflecting: error)
  }
}

extension Encodable where Self: AnalyticsEventProtocol {

  public func parameters(_ provider: AnalyticsProviderProtocol.Type) -> AnalyticsEventProtocol.Parameters {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }

}
