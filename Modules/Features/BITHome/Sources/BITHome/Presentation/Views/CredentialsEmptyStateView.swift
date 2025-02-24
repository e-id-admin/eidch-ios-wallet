import BITL10n
import BITTheming
import Factory
import SwiftUI

// MARK: - CredentialsEmptyStateView

struct CredentialsEmptyStateView: View {

  // MARK: Lifecycle

  init(betaIdAction: @escaping() -> Void, eIDRequestAction: @escaping() -> Void) {
    self.betaIdAction = betaIdAction
    self.eIDRequestAction = eIDRequestAction
  }

  // MARK: Internal

  var body: some View {
    VStack(alignment: .center, spacing: .x1) {
      if !sizeCategory.isAccessibilityCategory {
        HomeAssets.emptyWalletIcon.swiftUIImage
          .padding(.bottom, .x6)
          .accessibilityHidden(true)
      }

      Text(L10n.tkGetBetaIdFirstUseTitle)
        .multilineTextAlignment(.center)
        .font(.custom.title3)
        .foregroundStyle(ThemingAssets.Label.primary.swiftUIColor)
        .accessibilityLabel(L10n.tkGetBetaIdFirstUseTitle)
        .accessibilitySortPriority(AccessibilityPriority.x1.rawValue)

      Text(L10n.tkGetBetaIdFirstUseBody)
        .multilineTextAlignment(.center)
        .font(.custom.body)
        .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
        .accessibilityLabel(L10n.tkGetBetaIdFirstUseBody)
        .accessibilitySortPriority(AccessibilityPriority.x2.rawValue)

      if isEIDRequestFeatureEnabled {
        Button(action: eIDRequestAction, label: {
          Label(L10n.tkMenuHomeListOrderEid, systemImage: "arrow.forward")
        })
        .buttonStyle(.filledSecondary)
        .controlSize(.large)
        .accessibilityLabel(L10n.tkMenuHomeListOrderEid)
        .accessibilitySortPriority(AccessibilityPriority.x3.rawValue)
        .padding(.top, .x6)
      }

      Button(action: betaIdAction, label: {
        Label(title: { Text(L10n.tkGlobalGetbetaidPrimarybutton) }, icon: { Image(systemName: "arrow.forward") })
      })
      .buttonStyle(.filledSecondary)
      .controlSize(.large)
      .accessibilityLabel(L10n.tkGlobalGetbetaidPrimarybutton)
      .accessibilitySortPriority(AccessibilityPriority.x4.rawValue)
      .padding(.top, .x4)
    }
  }

  // MARK: Private

  private enum AccessibilityPriority: Double {
    case x1 = 100
    case x2 = 80
    case x3 = 50
    case x4 = 30
  }

  @Environment(\.sizeCategory) private var sizeCategory

  @Injected(\.isEIDRequestFeatureEnabled) private var isEIDRequestFeatureEnabled: Bool
  private let eIDRequestAction: () -> Void
  private let betaIdAction: () -> Void

}

#if DEBUG
#Preview {
  CredentialsEmptyStateView(betaIdAction: { }, eIDRequestAction: { })
}
#endif
