import BITL10n
import BITTheming
import Foundation
import SwiftUI

// MARK: - CompletionView

struct CompletionView: View {

  let router: OnboardingInternalRoutes

  var body: some View {
    InformationView(
      primary: L10n.onboardingReadyPrimary,
      secondary: L10n.onboardingReadySecondary,
      image: Assets.checkmarkCircle.swiftUIImage,
      backgroundColor: ThemingAssets.Background.secondary.swiftUIColor,
      buttonLabel: L10n.onboardingReadyButtonText)
    {
      router.context.onboardingDelegate?.didCompleteOnboarding()
    }
    .navigationBarBackButtonHidden(true)
  }
}
