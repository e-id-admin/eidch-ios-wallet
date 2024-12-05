import BITL10n
import BITTheming
import Foundation
import SwiftUI

// MARK: - CredentialIntroductionView

struct CredentialIntroductionView: View {

  let router: OnboardingInternalRoutes

  var body: some View {
    InformationView(
      primary: L10n.onboardingPresentPrimary,
      secondary: L10n.onboardingPresentSecondary,
      image: Assets.eId.swiftUIImage,
      backgroundImage: ThemingAssets.Gradient.gradient5.swiftUIImage,
      buttonLabel: L10n.globalContinue)
    {
      router.infoScreenSecurity()
    }
  }
}
