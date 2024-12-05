import SwiftUI

extension Color {

  // MARK: Lifecycle

  public init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0

    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0

    let length = hexSanitized.count

    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0

    } else if length == 8 {
      r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x000000FF) / 255.0

    } else {
      return nil
    }

    self.init(red: r, green: g, blue: b, opacity: a)
  }

  // MARK: Public

  public func hexStringThrows(_ includeAlpha: Bool = true) throws -> String {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0

    UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)

    guard r >= 0 && r <= 1 && g >= 0 && g <= 1 && b >= 0 && b <= 1 else {
      throw ColorError.cannotOutputHexColor
    }

    return includeAlpha ? String(format: "#%02X%02X%02X%02X", Int(round(r * 255)), Int(round(g * 255)), Int(round(b * 255)), Int(round(a * 255))) : String(format: "#%02X%02X%02X", Int(round(r * 255)), Int(round(g * 255)), Int(round(b * 255)))
  }

  public func hexString(_ includeAlpha: Bool = true) -> String {
    guard let hexString = try? hexStringThrows(includeAlpha) else { return "" }
    return hexString
  }
}

// MARK: - ColorError

public enum ColorError: Error {
  case cannotOutputHexColor
}
