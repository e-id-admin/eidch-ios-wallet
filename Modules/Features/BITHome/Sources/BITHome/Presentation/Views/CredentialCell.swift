import BITCredential
import BITCredentialShared
import BITL10n
import BITOpenID
import BITTheming
import SwiftUI

// MARK: - CredentialCell

struct CredentialCell: View {

  // MARK: Lifecycle

  init(_ credential: Credential) {
    self.credential = credential
  }

  // MARK: Internal

  var body: some View {
    VStack {
      HStack(alignment: alignment, spacing: .x3) {
        if sizeCategory <= .accessibilityLarge {
          CredentialCard(credential)
            .controlSize(.small)
        }

        VStack(alignment: .leading, spacing: 0) {
          Text(credential.preferredDisplay?.name ?? L10n.tkCredentialFallbackTitle)
            .font(.custom.body)
          if let summary = credential.preferredDisplay?.summary {
            Text(summary)
              .font(.custom.callout)
              .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
          }

          HStack(spacing: .x3) {
            if credential.environment == .demo {
              Text(L10n.tkGlobalCredentialStatusDemo)
            }

            HStack(spacing: .x1) {
              credential.status.image
                .aspectRatio(contentMode: .fit)
              Text(credential.status.text)
            }
            .foregroundStyle(credential.status.color)
          }
          .font(.custom.caption1)
          .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
          .padding(.top, 2)
        }
      }
      .readSize { size in
        alignment = size.height > cellMinHeight ? .top : .center
      }
    }
  }

  // MARK: Private

  @Environment(\.sizeCategory) private var sizeCategory

  @State private var alignment: VerticalAlignment = .center

  private let credential: Credential
  private let cellMinHeight: CGFloat = 96

  @ViewBuilder
  private func badge(_ status: VcStatus) -> some View {
    VStack {
      Badge {
        HStack(alignment: .center, spacing: 2) {
          if !sizeCategory.isAccessibilityCategory {
            status.image
              .aspectRatio(contentMode: .fit)
          }
          Text(status.text)
            .padding(.top, 2)
        }
        .font(.custom.caption1)
      }
      .badgeStyle(AnyBadgeStyle(style: status.badgeStyle))
    }
  }

}
