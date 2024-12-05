import Foundation
import Spyable

@Spyable
public protocol AnalyticsRepositoryProtocol {
  func allowAnalytics(_ allow: Bool) async
  func isAnalyticsAllowed() -> Bool
}
