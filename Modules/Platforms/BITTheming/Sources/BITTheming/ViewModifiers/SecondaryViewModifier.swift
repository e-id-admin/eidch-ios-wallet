import Foundation
import SwiftUI

public struct SecondaryViewModifier: ViewModifier {

  public init() {}

  public func body(content: Content) -> some View {
    content
      .padding()
      .frame(maxWidth: .infinity)
      .background(ThemingAssets.accentColor.swiftUIColor.opacity(0.1))
      .foregroundColor(ThemingAssets.accentColor.swiftUIColor)
      .cornerRadius(.standard)
      .progressViewStyle(CircularProgressViewStyle(tint: .white))
  }

}
