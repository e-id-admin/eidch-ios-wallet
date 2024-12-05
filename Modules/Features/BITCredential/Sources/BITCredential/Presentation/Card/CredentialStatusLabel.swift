import BITCredentialShared
import BITL10n
import BITOpenID
import BITTheming
import SwiftUI

public struct CredentialStatusLabel: View {

  // MARK: Lifecycle

  public init(status: VcStatus) {
    self.status = status
  }

  // MARK: Public

  public var body: some View {
    VStack {
      Badge {
        HStack(alignment: .center, spacing: .x1) {
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

  // MARK: Private

  @Environment(\.sizeCategory) private var sizeCategory

  private var status: VcStatus
}
