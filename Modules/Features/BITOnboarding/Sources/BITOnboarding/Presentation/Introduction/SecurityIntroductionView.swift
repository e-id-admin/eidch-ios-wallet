import BITL10n
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - SecurityIntroductionView

struct SecurityIntroductionView: View {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    viewModel = Container.shared.securityIntroductionViewModel(router)
  }

  // MARK: Internal

  var body: some View {
    InformationView(
      primary: L10n.tkOnboardingYourdataTitle,
      secondary: L10n.tkOnboardingYourdataBody,
      tertiary: L10n.tkOnboardingYourdataLinkText,
      tertiaryAction: viewModel.secondaryAction,
      isTertiaryTapable: true,
      image: Assets.shieldPerson.swiftUIImage,
      backgroundImage: ThemingAssets.Gradient.gradient7.swiftUIImage,
      primaryButtonLabel: L10n.tkGlobalContinue,
      primaryButtonAction: viewModel.primaryAction)
  }

  // MARK: Private

  private let viewModel: SecurityIntroductionViewModel

}

// MARK: - SecurityIntroductionViewModel

class SecurityIntroductionViewModel {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    self.router = router
  }

  // MARK: Internal

  let router: OnboardingInternalRoutes

  func secondaryAction() {
    guard let url = URL(string: L10n.tkOnboardingYourdataLinkValue) else { return }
    router.openExternalLink(url: url)
  }

  func primaryAction() {
    router.infoScreenCredential()
  }

}
