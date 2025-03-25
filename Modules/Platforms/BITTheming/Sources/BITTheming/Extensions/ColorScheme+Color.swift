import Foundation
import SwiftUI
import UIKit

extension ColorScheme {
  public func standardColor() -> Color {
    self == .dark ? ThemingAssets.Grays.white.swiftUIColor : ThemingAssets.Grays.black.swiftUIColor
  }
}

extension ColorAsset {
  public var light: Color {
    color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
  }

  public var dark: Color {
    color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
  }
}
