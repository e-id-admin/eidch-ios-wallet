import BITTheming
import SwiftUI

// MARK: - SecondaryMenuCell

struct SecondaryMenuCell: View {

  // MARK: Lifecycle

  init(primary: String, secondary: String, disclosureIndicator: DisclosureIndicator = .none, _ onTap: (() -> Void)? = nil) {
    self.primary = Text(primary)
    self.secondary = Text(secondary)
    self.disclosureIndicator = disclosureIndicator.image
    self.onTap = onTap
  }

  // MARK: Internal

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .firstTextBaseline, spacing: .x4) {
        primary
        Spacer()
        secondary
          .font(.custom.footnote)
          .foregroundStyle(ThemingAssets.secondary.swiftUIColor)
        if let disclosureIndicator {
          disclosureIndicator
        }
      }

      if hasDivider {
        Rectangle()
          .frame(maxWidth: .infinity, maxHeight: 1)
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

  private var primary: Text
  private var secondary: Text
  private var disclosureIndicator: Image?
  private var onTap: (() -> Void)?

}
