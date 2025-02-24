import BITTheming
import SwiftUI

// MARK: - MenuCell

struct MenuCell: View {

  // MARK: Lifecycle

  init(systemImage: String? = nil, text: String, disclosureIndicator: DisclosureIndicator = .none, _ onTap: (() -> Void)? = nil) {
    if let systemImage {
      image = Image(systemName: systemImage)
    }
    self.text = Text(text)
    self.disclosureIndicator = disclosureIndicator.image
    self.onTap = onTap
  }

  // MARK: Internal

  enum Const {
    static let iconFrame: CGFloat = 25
    static let spacingHStack = CGFloat.x5
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .firstTextBaseline, spacing: .x4) {
        if let image {
          image
            .frame(width: Const.iconFrame)
        }

        HStack(alignment: .firstTextBaseline) {
          text

          Spacer(minLength: .x2)

          if let disclosureIndicator {
            disclosureIndicator
          }
        }
      }

      if hasDivider {
        Rectangle()
          .frame(maxWidth: .infinity, maxHeight: 1)
          .if(image != nil, transform: {
            $0.padding(.leading, Const.iconFrame + Const.spacingHStack)
          })
          .foregroundStyle(ThemingAssets.gray3.swiftUIColor)
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      onTap?()
    }
  }

  // MARK: Private

  @Environment(\.menuCellDivider) private var hasDivider: Bool

  private var image: Image?
  private var text: Text
  private var disclosureIndicator: Image?
  private var onTap: (() -> Void)?

}

// MARK: - MenuCellDividerKey

struct MenuCellDividerKey: EnvironmentKey {
  static var defaultValue = true
}

extension EnvironmentValues {
  var menuCellDivider: Bool {
    get { self[MenuCellDividerKey.self] }
    set { self[MenuCellDividerKey.self] = newValue }
  }
}

extension View {
  func hasDivider(_ value: Bool) -> some View {
    environment(\.menuCellDivider, value)
  }
}
