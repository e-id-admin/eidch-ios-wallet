import Foundation
import SwiftUI

// MARK: - ButtonStackView

public struct ButtonStackView<Content: View>: View {

  // MARK: Lifecycle

  public init(@ViewBuilder _ content: @escaping () -> Content) {
    self.content = content
  }

  // MARK: Public

  public var body: some View {
    Group {
      if sizeCategory.isAccessibilityCategory {
        VStack(spacing: .x2) {
          content()
        }
      } else {
        HStack(spacing: .x2) {
          content()
        }
      }
    }
  }

  // MARK: Internal

  @Environment(\.sizeCategory) var sizeCategory

  let content: () -> Content

}
