import SwiftUI

public struct ProgressViewLabelBadge: View {

  // MARK: Lifecycle

  public init(text: String, background: Color, foreground: Color? = nil) {
    self.text = text
    self.background = background
    self.foreground = foreground

  }

  // MARK: Public

  public var body: some View {
    HStack(spacing: .x2) {
      ProgressView()
        .tint(foreground)

      Text(text)
        .font(.custom.footnote)
        .accessibilityLabel(text)
    }
    .padding(.horizontal, .x4)
    .padding(.vertical, .x2)
    .background(background)
    .clipShape(.rect(cornerRadius: .x6))
  }

  // MARK: Private

  private let text: String
  private let background: Color
  private let foreground: Color?
}
