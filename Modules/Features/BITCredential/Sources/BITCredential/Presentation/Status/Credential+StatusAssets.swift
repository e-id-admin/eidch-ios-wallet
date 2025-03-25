import BITCore
import BITCredentialShared
import BITL10n
import BITOpenID
import BITTheming
import SwiftUI

extension Credential {

  // MARK: Public

  public var statusText: String {
    switch status {
    case .valid: L10n.tkGlobalCredentialStatusValid
    case .expired: L10n.tkGlobalCredentialStatusInvalid
    case .notYetValid: getNotYetValidText()
    case .revoked: L10n.tkGlobalCredentialStatusRevoked
    case .suspended: L10n.tkGlobalCredentialStatusSuspended
    case .unknown,
         .unsupported: L10n.tkGlobalCredentialStatusUnknown
    }
  }

  public var statusTextAlt: String {
    switch status {
    case .valid: L10n.tkGlobalCredentialStatusValidAlt
    case .expired: L10n.tkGlobalCredentialStatusInvalidAlt
    case .notYetValid: getNotYetValidAltText()
    case .revoked: L10n.tkGlobalCredentialStatusRevokedAlt
    case .suspended: L10n.tkGlobalCredentialStatusSuspendedAlt
    case .unknown,
         .unsupported: L10n.tkGlobalCredentialStatusUnknownAlt
    }
  }

  public var statusImage: Image {
    switch status {
    case .valid: Assets.statusValid.swiftUIImage
    case .expired: Assets.statusInvalid.swiftUIImage
    case .notYetValid: Assets.statusNotYetValid.swiftUIImage
    case .revoked: Assets.statusInvalid.swiftUIImage
    case .suspended: Assets.statusSuspended.swiftUIImage
    case .unknown,
         .unsupported: Assets.statusUnknown.swiftUIImage
    }
  }

  public var statusColor: Color {
    switch status {
    case .unknown,
         .unsupported,
         .valid: ThemingAssets.Label.secondary.swiftUIColor
    case .expired,
         .notYetValid,
         .revoked,
         .suspended: ThemingAssets.Brand.Core.swissRed.swiftUIColor
    }
  }

  public var statusBadgeStyle: any BadgeStyle {
    switch status {
    case .unknown,
         .unsupported,
         .valid: .outline
    case .expired,
         .notYetValid,
         .revoked,
         .suspended: .error
    }
  }

  // MARK: Private

  private func getNotYetValidText() -> String {
    guard let date = validFrom else { return L10n.tkGlobalCredentialStatusUnknown }
    return if date.isWithinNext24Hours {
      L10n.tkGlobalCredentialStatusSoon
    } else if let days = date.numberOfDaysSince(Date()) {
      L10n.tkGlobalCredentialStatusValidindaysIos(days)
    } else {
      L10n.tkGlobalCredentialStatusUnknown
    }
  }

  private func getNotYetValidAltText() -> String {
    guard let date = validFrom else { return L10n.tkGlobalCredentialStatusUnknown }
    return if date.isWithinNext24Hours {
      L10n.tkGlobalCredentialStatusSoonAlt
    } else if let days = date.numberOfDaysSince(Date()) {
      L10n.tkGlobalCredentialStatusValidindaysIosAlt(days)
    } else {
      L10n.tkGlobalCredentialStatusUnknownAlt
    }
  }
}
