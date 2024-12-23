import BITL10n
import BITTheming
import Foundation
import SwiftUI

// MARK: - CompletionErrorView

struct CompletionErrorView: View {

  let router: OnboardingInternalRoutes
  weak var delegate: SetupDelegate?

  var body: some View {
    InformationView(
      primary: L10n.onboardingSetupErrorPrimary,
      secondary: L10n.onboardingSetupErrorSecondary,
      image: Assets.xmarkCircle.swiftUIImage,
      backgroundColor: ThemingAssets.Background.secondary.swiftUIColor,
      buttonLabel: L10n.onboardingSetupErrorButtonText)
    {
      delegate?.restartSetup()
      router.pop()
    }
    .navigationBarBackButtonHidden(true)
  }
}
