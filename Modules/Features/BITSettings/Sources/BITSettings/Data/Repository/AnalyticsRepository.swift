import BITAnalytics
import Factory
import Foundation

struct AnalyticsRepository: AnalyticsRepositoryProtocol {
  private let analytics: AnalyticsProtocol

  init(analytics: AnalyticsProtocol = Container.shared.analytics()) {
    self.analytics = analytics
  }

  func allowAnalytics(_ allow: Bool) async {
    await analytics.applyUserPrivacyPolicy(allow)
  }

  func isAnalyticsAllowed() -> Bool {
    analytics.isAnalyticsEnabled
  }
}
