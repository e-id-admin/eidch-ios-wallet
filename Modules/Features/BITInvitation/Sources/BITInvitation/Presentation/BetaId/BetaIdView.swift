import BITL10n
import BITTheming
import Factory
import SwiftUI

struct BetaIdView: View {

  // MARK: Lifecycle

  init(router: InvitationRouterRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.betaIdViewModel(router))
  }

  // MARK: Internal

  @StateObject var viewModel: BetaIdViewModel

  var body: some View {
    InformationView(
      primary: L10n.tkGetBetaIdCreateTitle,
      secondary: L10n.tkGetBetaIdCreateBody,
      image: Assets.betaId.swiftUIImage,
      backgroundColor: ThemingAssets.Background.secondary.swiftUIColor,
      primaryButtonLabel: L10n.tkGlobalGetbetaidPrimarybutton,
      primaryButtonAction: viewModel.openBetaIdLink)
  }
}

#Preview {
  BetaIdView(router: InvitationRouter())
}
