import SwiftUI

public enum DisclosureIndicator {
  case none
  case externalLink
  case navigation
  case custom(_ systemName: String)

  public var image: Image? {
    switch self {
    case .none: nil
    case .externalLink: Image(systemName: "arrow.up.right")
    case .navigation: Image(systemName: "arrow.right")
    case .custom(let systemName): Image(systemName: systemName)
    }
  }
}
