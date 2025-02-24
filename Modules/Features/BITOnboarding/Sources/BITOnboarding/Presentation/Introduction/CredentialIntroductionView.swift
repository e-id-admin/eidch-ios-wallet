import BITL10n
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - CredentialIntroductionView

struct CredentialIntroductionView: View {

  init(router: OnboardingInternalRoutes) {
    viewModel = Container.shared.credentialIntroductionViewModel(router)
  }

  private let viewModel: CredentialIntroductionViewModel

  var body: some View {
    InformationView(
      primary: L10n.tkOnboardingNeverforgetTitle,
      secondary: L10n.tkOnboardingNeverforgetBody,
      image: Assets.eId.swiftUIImage,
      backgroundImage: ThemingAssets.Gradient.gradient5.swiftUIImage,
      primaryButtonLabel: L10n.tkGlobalContinue,
      primaryButtonAction: viewModel.primaryAction)
  }
}

// MARK: - CredentialIntroductionViewModel

class CredentialIntroductionViewModel {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    self.router = router
  }

  // MARK: Internal

  let router: OnboardingInternalRoutes

  func primaryAction() {
    router.privacyPermission()
  }

}
