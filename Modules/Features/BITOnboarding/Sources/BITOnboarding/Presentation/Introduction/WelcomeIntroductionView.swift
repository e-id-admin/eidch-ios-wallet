import BITL10n
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - WelcomeIntroductionView

struct WelcomeIntroductionView: View {

  private let viewModel: WelcomeIntroductionViewModel

  init(router: OnboardingInternalRoutes) {
    viewModel = Container.shared.welcomeIntroductionViewModel(router)
  }

  var body: some View {
    InformationView(
      primary: L10n.tkOnboardingStartTitle,
      primaryAlt: L10n.tkOnboardingStartAlt,
      secondary: L10n.tkOnboardingStartBody,
      image: Assets.shieldCross.swiftUIImage,
      primaryButtonLabel: L10n.tkOnboardingStartPrimarybutton,
      primaryButtonAction: viewModel.primaryAction)
  }
}

// MARK: - WelcomeIntroductionViewModel

class WelcomeIntroductionViewModel {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    self.router = router
  }

  // MARK: Internal

  let router: OnboardingInternalRoutes

  func primaryAction() {
    router.infoScreenSecurity()
  }

}
