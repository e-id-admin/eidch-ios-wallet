import BITL10n
import BITOpenID
import BITTheming
import SwiftUI

extension VcStatus {

  public var text: String {
    switch self {
    case .valid: L10n.tkGlobalCredentialStatusValid
    case .revoked: L10n.tkGlobalCredentialStatusRevoked
    case .suspended: L10n.tkGlobalCredentialStatusSuspended
    case .unknown,
         .unsupported: L10n.tkGlobalCredentialStatusUnknown
    }
  }

  public var textAlt: String {
    switch self {
    case .valid: L10n.tkGlobalCredentialStatusValidAlt
    case .revoked: L10n.tkGlobalCredentialStatusRevokedAlt
    case .suspended: L10n.tkGlobalCredentialStatusSuspendedAlt
    case .unknown,
         .unsupported: L10n.tkGlobalCredentialStatusUnknownAlt
    }
  }

  public var image: Image {
    switch self {
    case .valid: Assets.statusValid.swiftUIImage
    case .revoked: Assets.statusInvalid.swiftUIImage
    case .suspended: Assets.statusSuspended.swiftUIImage
    case .unknown,
         .unsupported: Assets.statusUnknown.swiftUIImage
    }
  }

  public var color: Color {
    switch self {
    case .unknown,
         .unsupported,
         .valid: ThemingAssets.Label.secondary.swiftUIColor
    case .revoked,
         .suspended: ThemingAssets.Brand.Core.swissRed.swiftUIColor
    }
  }

  public var badgeStyle: any BadgeStyle {
    switch self {
    case .unknown,
         .unsupported,
         .valid: .plain
    case .revoked,
         .suspended: .secondaryError
    }
  }
}
