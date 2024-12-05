import Foundation
import UIKit

// MARK: - ExternalRoutes

public protocol ExternalRoutes {
  func settings()
  func openExternalLink(url: URL)
}

extension ExternalRoutes {
  public func settings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }

  public func openExternalLink(url: URL) {
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
