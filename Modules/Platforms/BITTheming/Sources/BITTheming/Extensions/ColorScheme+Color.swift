import Foundation
import SwiftUI
import UIKit

extension ColorScheme {
  public func standardColor() -> Color {
    self == .dark ? ThemingAssets.Grays.white.swiftUIColor : ThemingAssets.Grays.black.swiftUIColor
  }
}
