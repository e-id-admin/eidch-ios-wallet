import Foundation
import UIKit

// MARK: - Vibrating

public protocol Vibrating {
  func vibrate(_ type: UINotificationFeedbackGenerator.FeedbackType)
}

extension Vibrating {
  public func vibrate(_ type: UINotificationFeedbackGenerator.FeedbackType = .error) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
  }
}
