import BITL10n
import BITTheming
import Factory
import SwiftUI

struct QueueInformationView: View {

  // MARK: Lifecycle

  init(router: EIDRequestInternalRoutes, onlineSessionStartDate: Date) {
    viewModel = Container.shared.queueInformationViewModel((router, onlineSessionStartDate))
  }

  // MARK: Internal

  var body: some View {
    InformationView(
      primary: L10n.tkGetEidQueuingTitle,
      secondary: L10n.tkGetEidQueuingBody,
      tertiary: L10n.tkGetEidQueuingBody2Ios(viewModel.expectedOnlineSessionStart ?? "-"),
      image: Assets.timer.swiftUIImage,
      backgroundColor: ThemingAssets.Background.secondary.swiftUIColor,
      primaryButtonLabel: L10n.tkGlobalContinue,
      primaryButtonAction: viewModel.primaryAction)
      .navigationBarBackButtonHidden(true)
  }

  // MARK: Private

  private var viewModel: QueueInformationViewViewModel
}
