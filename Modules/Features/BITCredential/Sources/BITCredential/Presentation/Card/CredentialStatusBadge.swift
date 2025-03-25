import BITCredentialShared
import BITL10n
import BITOpenID
import BITTheming
import SwiftUI

// MARK: - CredentialStatusBadge

public struct CredentialStatusBadge: View {

  // MARK: Lifecycle

  public init(credential: Credential) {
    self.credential = credential
  }

  // MARK: Public

  public var body: some View {
    VStack {
      Badge {
        Label(title: {
          Text(credential.statusText)
        }, icon: {
          if !sizeCategory.isAccessibilityCategory {
            credential.statusImage
              .resizable()
              .scaledToFit()
              .frame(width: Defaults.imageWidth, height: Defaults.imageHeight)
          }
        }) }
        .accessibilityLabel(credential.statusTextAlt)
        .badgeStyle(AnyBadgeStyle(style: credential.statusBadgeStyle))
    }
  }

  // MARK: Private

  private enum Defaults {
    static let imageWidth: CGFloat = 14
    static let imageHeight: CGFloat = 18
  }

  @Environment(\.sizeCategory) private var sizeCategory

  private var credential: Credential

}

#if DEBUG
#Preview {
  VStack {
    CredentialStatusBadge(credential: .Mock.sample)
  }.background(.blue)
}
#endif
