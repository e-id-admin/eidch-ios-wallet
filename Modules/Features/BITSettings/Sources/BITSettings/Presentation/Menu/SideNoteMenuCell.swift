import BITTheming
import SwiftUI

// MARK: - SideNoteMenuCell

struct SideNoteMenuCell: View {

  // MARK: Lifecycle

  init(text: String, sidenote: String, disclosureIndicator: DisclosureIndicator = .none, _ onTap: (() -> Void)? = nil) {
    self.text = Text(text)
    self.sidenote = Text(sidenote)
    self.disclosureIndicator = disclosureIndicator.image
    self.onTap = onTap
  }

  // MARK: Internal

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .firstTextBaseline, spacing: .x4) {
        text
        Spacer()
        sidenote
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

  private var text: Text
  private var sidenote: Text
  private var disclosureIndicator: Image?
  private var onTap: (() -> Void)?

}
