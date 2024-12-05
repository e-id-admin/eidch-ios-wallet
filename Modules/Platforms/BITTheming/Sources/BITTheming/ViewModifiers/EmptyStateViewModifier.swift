import Foundation
import SwiftUI

// MARK: - EmptyStateViewModifier

public struct EmptyStateViewModifier: ViewModifier {

  let color: Color

  public func body(content: Content) -> some View {
    content
      .aspectRatio(1, contentMode: .fit)
      .frame(width: 170)
      .foregroundColor(color)
      .padding(.top, .x10)
  }

}

extension Image {
  public func emptyStateImage(color: Color) -> some View {
    resizable()
      .modifier(EmptyStateViewModifier(color: color))
  }
}
