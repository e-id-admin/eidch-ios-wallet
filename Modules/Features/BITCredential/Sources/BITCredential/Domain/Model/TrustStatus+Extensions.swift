import BITCredentialShared
import BITL10n
import BITTheming
import SwiftUI

extension TrustStatus {
  public var icon: Image {
    switch self {
    case .verified:
      Assets.trustBadge.swiftUIImage
    case .unverified:
      Assets.notTrustedBadge.swiftUIImage
    }
  }

  public var description: String {
    switch self {
    case .verified: L10n.tkReceiveTrustedIssuerText
    case .unverified: L10n.tkReceiveNotTrustedIssuerText
    }
  }

  public var color: Color {
    switch self {
    case .verified:
      ThemingAssets.Brand.Core.firGreen.swiftUIColor
    case .unverified:
      ThemingAssets.Brand.Bright.yellowLabel.swiftUIColor
    }
  }
}
