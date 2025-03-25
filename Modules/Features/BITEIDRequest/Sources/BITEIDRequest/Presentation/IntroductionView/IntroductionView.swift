import BITL10n
import BITTheming
import Factory
import SwiftUI

struct IntroductionView: View {

  // MARK: Lifecycle

  init(router: EIDRequestInternalRoutes) {
    viewModel = Container.shared.introductionViewModel(router)
  }

  // MARK: Internal

  var body: some View {
    InformationView(
      image: Assets.card.swiftUIImage,
      backgroundColor: ThemingAssets.Background.secondary.swiftUIColor,
      content: {
        DefaultInformationContentView(
          primary: L10n.tkGetEidIntroTitle,
          secondary: L10n.tkGetEidIntroBody,
          tertiary: L10n.tkGetEidIntroSmallBody)
      },
      footer: {
        DefaultInformationFooterView(
          primaryButtonLabel: L10n.tkGetEidIntroPrimaryButton,
          primaryButtonAction: viewModel.openDataPrivacy,
          secondaryButtonLabel: L10n.tkGetEidIntroSecondaryButton,
          secondaryButtonAction: viewModel.close)
      })
  }

  // MARK: Private

  private var viewModel: IntroductionViewModel

}

#Preview {
  IntroductionView(router: EIDRequestRouter())
}
