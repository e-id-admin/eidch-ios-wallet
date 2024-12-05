import BITL10n
import BITTheming
import Foundation
import SwiftUI

// MARK: - SecurityIntroductionView

struct SecurityIntroductionView: View {

  let router: OnboardingInternalRoutes

  var body: some View {
    InformationView(
      primary: L10n.onboardingSecurityPrimary,
      secondary: L10n.onboardingSecuritySecondary,
      tertiary: L10n.onboardingSecurityDetails,
      image: Assets.shieldPerson.swiftUIImage,
      backgroundImage: ThemingAssets.Gradient.gradient7.swiftUIImage,
      buttonLabel: L10n.onboardingContinue)
    {
      router.privacyPermission()
    }
  }
}
