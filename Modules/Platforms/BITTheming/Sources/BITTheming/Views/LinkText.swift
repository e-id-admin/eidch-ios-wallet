import SwiftUI

// MARK: - LinkText

public struct LinkText: View {

  private let text: String

  public init(_ text: String) {
    self.text = text
  }

  public var body: some View {
    HStack(alignment: .lastTextBaseline, spacing: .x1) {
      Text(text)
      Image(systemName: "chevron.right")
        .font(.caption)
    }
    .multilineTextAlignment(.leading)
    .foregroundStyle(ThemingAssets.Brand.Bright.swissRedLabel.swiftUIColor)
    .accessibilityElement(children: .combine)
  }
}

// MARK: - ButtonLinkText

public struct ButtonLinkText: View {

  // MARK: Lifecycle

  public init(_ text: String, _ action: @escaping () -> Void) {
    self.text = text
    self.action = action
  }

  // MARK: Public

  public var body: some View {
    Button(action: action, label: {
      LinkText(text)
    })
    .accessibilityLabel(text)
    .accessibilityRemoveTraits(.isButton)
    .accessibilityAddTraits(.isLink)
  }

  // MARK: Private

  private let text: String
  private let action: () -> Void

}

#Preview {
  ButtonLinkText("Test", {})
}

#Preview {
  LinkText("Test")
}
