import BITL10n
import BITTheming
import SwiftUI

struct CompletionView: View {

  let router: OnboardingInternalRoutes

  var body: some View {
    InformationView(
      primary: L10n.tkOnboardingAllsetTitle,
      secondary: L10n.tkOnboardingAllsetBody,
      image: Assets.checkmarkCircle.swiftUIImage,
      backgroundColor: ThemingAssets.Background.secondary.swiftUIColor,
      primaryButtonLabel: L10n.tkGlobalContinue,
      primaryButtonAction: {
        router.context.onboardingDelegate?.didCompleteOnboarding()
      })
      .navigationBarBackButtonHidden(true)
  }
}
