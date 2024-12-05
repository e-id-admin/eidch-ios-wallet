import BITL10n
import BITOpenID
import BITTheming
import SwiftUI

// MARK: - CredentialStatusBadge

public struct CredentialStatusBadge: View {

  // MARK: Lifecycle

  public init(status: VcStatus) {
    self.status = status
  }

  // MARK: Public

  public var body: some View {
    VStack {
      Badge { Label(title: { Text(status.text) }, icon: {
        if !sizeCategory.isAccessibilityCategory {
          status.image
            .resizable()
            .scaledToFit()
            .frame(width: Defaults.imageWidth, height: Defaults.imageHeight)
        }
      }) }
      .accessibilityLabel(status.textAlt)
      .badgeStyle(AnyBadgeStyle(style: status.style))
    }
  }

  // MARK: Private

  private enum Defaults {
    static let imageWidth: CGFloat = 14
    static let imageHeight: CGFloat = 18
  }

  @Environment(\.sizeCategory) private var sizeCategory

  private var status: VcStatus

}

extension VcStatus {

  var style: any BadgeStyle {
    switch self {
    case .unknown,
         .unsupported,
         .valid: .outline
    case .revoked,
         .suspended: .error
    }
  }

}

#Preview {
  VStack {
    CredentialStatusBadge(status: .valid)
  }.background(.blue)
}
