import Foundation
import SwiftUI
import UIKit

extension UIFont {

  public class func preferredFont(forTextStyle style: UIFont.TextStyle, font: FontConvertible, size: CGFloat? = nil) -> UIFont {
    let metrics = UIFontMetrics(forTextStyle: style)
    let descriptor = preferredFont(forTextStyle: style).fontDescriptor
    let defaultSize = descriptor.pointSize
    let fontToScale: UIFont = font.font(size: size ?? defaultSize)
    return metrics.scaledFont(for: fontToScale)
  }

}

extension SwiftUI.Font {
  public static let custom = ABCDiatype.self
  public static let mono = ABCDiatypeRoundedSemiMono.self
}

// MARK: - SwiftUI.Font.ABCDiatype

extension SwiftUI.Font {
  public struct ABCDiatype {
    public static var titleLarge: SwiftUI.Font = FontFamily.ABCDiatype.regular.swiftUIFont(size: 34, relativeTo: .largeTitle)
    public static var titleLargeEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.medium.swiftUIFont(size: 34, relativeTo: .largeTitle)

    public static var title: SwiftUI.Font = FontFamily.ABCDiatype.regular.swiftUIFont(size: 28, relativeTo: .title)
    public static var titleEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.medium.swiftUIFont(size: 28, relativeTo: .title)

    public static var title2: SwiftUI.Font = FontFamily.ABCDiatype.regular.swiftUIFont(size: 22, relativeTo: .title2)
    public static var title2Emphasized: SwiftUI.Font = FontFamily.ABCDiatype.medium.swiftUIFont(size: 22, relativeTo: .title2)

    public static var title3: SwiftUI.Font = FontFamily.ABCDiatype.regular.swiftUIFont(size: 20, relativeTo: .title2)
    public static var title3Emphasized: SwiftUI.Font = FontFamily.ABCDiatype.medium.swiftUIFont(size: 20, relativeTo: .title2)

    public static var headline: SwiftUI.Font = FontFamily.ABCDiatype.medium.swiftUIFont(size: 17, relativeTo: .headline)
    public static var headlineEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.regularItalic.swiftUIFont(size: 17, relativeTo: .headline)

    public static var body: SwiftUI.Font = FontFamily.ABCDiatype.regular.swiftUIFont(size: 17, relativeTo: .body)
    public static var bodyItalic: SwiftUI.Font = FontFamily.ABCDiatype.regularItalic.swiftUIFont(size: 17, relativeTo: .body)
    public static var bodyEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.medium.swiftUIFont(size: 17, relativeTo: .body)
    public static var bodyItalicEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.mediumItalic.swiftUIFont(size: 17, relativeTo: .body)

    public static var callout: SwiftUI.Font = FontFamily.ABCDiatype.regular.swiftUIFont(size: 16, relativeTo: .callout)
    public static var calloutItalic: SwiftUI.Font = FontFamily.ABCDiatype.regularItalic.swiftUIFont(size: 16, relativeTo: .callout)
    public static var calloutEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.medium.swiftUIFont(size: 16, relativeTo: .callout)
    public static var calloutItalicEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.mediumItalic.swiftUIFont(size: 16, relativeTo: .callout)

    public static var subheadline: SwiftUI.Font = FontFamily.ABCDiatype.regular.swiftUIFont(size: 15, relativeTo: .subheadline)
    public static var subheadlineItalic: SwiftUI.Font = FontFamily.ABCDiatype.regularItalic.swiftUIFont(size: 15, relativeTo: .subheadline)
    public static var subheadlineEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.medium.swiftUIFont(size: 15, relativeTo: .subheadline)
    public static var subheadlineItalicEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.mediumItalic.swiftUIFont(size: 15, relativeTo: .subheadline)

    public static var footnote: SwiftUI.Font = FontFamily.ABCDiatype.regular.swiftUIFont(size: 13, relativeTo: .footnote)
    public static var footnoteItalic: SwiftUI.Font = FontFamily.ABCDiatype.regularItalic.swiftUIFont(size: 13, relativeTo: .footnote)
    public static var footnoteEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.medium.swiftUIFont(size: 13, relativeTo: .footnote)
    public static var footnoteItalicEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.mediumItalic.swiftUIFont(size: 13, relativeTo: .footnote)

    public static var caption1: SwiftUI.Font = FontFamily.ABCDiatype.regular.swiftUIFont(size: 12, relativeTo: .caption)
    public static var caption1Italic: SwiftUI.Font = FontFamily.ABCDiatype.regularItalic.swiftUIFont(size: 12, relativeTo: .caption)
    public static var caption1Emphasized: SwiftUI.Font = FontFamily.ABCDiatype.medium.swiftUIFont(size: 12, relativeTo: .caption)
    public static var caption1ItalicEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.mediumItalic.swiftUIFont(size: 12, relativeTo: .caption)

    public static var caption2: SwiftUI.Font = FontFamily.ABCDiatype.regular.swiftUIFont(size: 11, relativeTo: .caption2)
    public static var caption2Italic: SwiftUI.Font = FontFamily.ABCDiatype.regularItalic.swiftUIFont(size: 11, relativeTo: .caption2)
    public static var caption2Emphasized: SwiftUI.Font = FontFamily.ABCDiatype.medium.swiftUIFont(size: 11, relativeTo: .caption2)
    public static var caption2ItalicEmphasized: SwiftUI.Font = FontFamily.ABCDiatype.mediumItalic.swiftUIFont(size: 11, relativeTo: .caption2)
  }

  public struct ABCDiatypeRoundedSemiMono {
    public static var title: SwiftUI.Font = FontFamily.ABCDiatypeRoundedSemiMono.medium.swiftUIFont(size: 24, relativeTo: .title)
    public static var title2: SwiftUI.Font = FontFamily.ABCDiatypeRoundedSemiMono.medium.swiftUIFont(size: 18, relativeTo: .title2)
    public static var headline: SwiftUI.Font = FontFamily.ABCDiatypeRoundedSemiMono.medium.swiftUIFont(size: 16, relativeTo: .headline)
    public static var headline2: SwiftUI.Font = FontFamily.ABCDiatypeRoundedSemiMono.medium.swiftUIFont(size: 16, relativeTo: .headline)
    public static var body: SwiftUI.Font = FontFamily.ABCDiatypeRoundedSemiMono.regular.swiftUIFont(size: 16, relativeTo: .body)
    public static var textLink: SwiftUI.Font = FontFamily.ABCDiatypeRoundedSemiMono.regular.swiftUIFont(size: 16, relativeTo: .body)
    public static var textLink2: SwiftUI.Font = FontFamily.ABCDiatypeRoundedSemiMono.bold.swiftUIFont(size: 12, relativeTo: .body)
    public static var subheadline: SwiftUI.Font = FontFamily.ABCDiatypeRoundedSemiMono.regular.swiftUIFont(size: 14, relativeTo: .subheadline)
    public static var footnote: SwiftUI.Font = FontFamily.ABCDiatypeRoundedSemiMono.medium.swiftUIFont(size: 12, relativeTo: .footnote)
    public static var footnote2: SwiftUI.Font = FontFamily.ABCDiatypeRoundedSemiMono.regular.swiftUIFont(size: 12, relativeTo: .footnote)
    public static var light: SwiftUI.Font = FontFamily.ABCDiatypeRoundedSemiMono.light.swiftUIFont(size: 12)
  }
}
