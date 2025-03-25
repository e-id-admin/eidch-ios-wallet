import BITL10n
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - WelcomeIntroductionView

struct WelcomeIntroductionView: View {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    viewModel = Container.shared.welcomeIntroductionViewModel(router)
  }

  // MARK: Internal

  var body: some View {
    InformationView(
      image: Assets.shieldCross.swiftUIImage,
      content: {
        DefaultInformationContentView(
          primary: L10n.tkOnboardingIntroductionStepSecurityPrimary,
          primaryAlt: L10n.tkOnboardingIntroductionStepSecurityScreenAlt,
          secondary: L10n.tkOnboardingIntroductionStepSecuritySecondary)
      },
      footer: {
        DefaultInformationFooterView(
          primaryButtonLabel: L10n.tkOnboardingIntroductionStepSecurityButtonPrimary,
          primaryButtonAction: viewModel.primaryAction)
      })
  }

  // MARK: Private

  private let viewModel: WelcomeIntroductionViewModel

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
