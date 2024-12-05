import BITL10n
import BITTheming
import Foundation
import SwiftUI

// MARK: - WelcomeIntroductionView

struct WelcomeIntroductionView: View {

  let router: OnboardingInternalRoutes

  var body: some View {
    InformationView(
      primary: L10n.onboardingIntroPrimary,
      primaryAlt: L10n.onboardingIntroPrimaryAlt,
      secondary: L10n.onboardingIntroSecondary,
      tertiary: L10n.onboardingIntroDetails,
      image: Assets.shieldCross.swiftUIImage,
      buttonLabel: L10n.onboardingIntroButtonText)
    {
      router.infoScreenCredential()
    }
  }
}
