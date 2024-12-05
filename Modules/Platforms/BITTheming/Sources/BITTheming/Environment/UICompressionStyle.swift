import SwiftUI

// MARK: - Compression

public enum UICompressionStyle {
  case large
  case normal
  case small

  public var isCompressed: Bool {
    self == .small
  }

  public init(height: CGFloat) {
    self = height > 750 ? (height > 1200 ? .large : .normal) : .small
  }
}
