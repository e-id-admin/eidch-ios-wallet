import BITL10n
import BITTheming
import SwiftUI

// MARK: - CredentialsEmptyStateView

struct CredentialsEmptyStateView: View {

  // MARK: Internal

  var body: some View {
    VStack(alignment: .center, spacing: .x1) {
      if !sizeCategory.isAccessibilityCategory {
        HomeAssets.emptyWalletIcon.swiftUIImage
          .padding(.bottom, .x6)
          .accessibilityHidden(true)
      }

      Text(L10n.tkHomeFirstuseTitle)
        .multilineTextAlignment(.center)
        .font(.custom.title3)
        .foregroundStyle(ThemingAssets.Label.primary.swiftUIColor)
        .accessibilityLabel(L10n.tkHomeFirstuseTitle)
        .accessibilitySortPriority(200)

      Text(L10n.tkHomeFirstuseBody)
        .multilineTextAlignment(.center)
        .font(.custom.body)
        .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
        .accessibilityLabel(L10n.tkHomeFirstuseBody)
        .accessibilitySortPriority(180)
    }
  }

  // MARK: Private

  @Environment(\.sizeCategory) private var sizeCategory

}

#if DEBUG
#Preview {
  CredentialsEmptyStateView()
}
#endif
