import Foundation

public protocol PrivacySettable {
  var isAnalyticsEnabled: Bool { get }
  func applyUserPrivacyPolicy(_ isEnabled: Bool) async
}
