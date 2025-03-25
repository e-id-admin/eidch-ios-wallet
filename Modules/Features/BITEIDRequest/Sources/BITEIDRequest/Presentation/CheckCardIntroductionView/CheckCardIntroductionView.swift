import BITL10n
import BITTheming
import Factory
import SwiftUI

struct CheckCardIntroductionView: View {

  // MARK: Lifecycle

  init(router: EIDRequestInternalRoutes) {
    viewModel = Container.shared.checkCardIntroductionViewModel(router)
  }

  // MARK: Internal

  var body: some View {
    InformationView(
      image: Assets.checkCard.swiftUIImage,
      backgroundColor: ThemingAssets.Background.secondary.swiftUIColor,
      content: {
        DefaultInformationContentView(
          primary: L10n.tkGetEidCheckIdTitle,
          secondary: L10n.tkGetEidCheckIdBody)
      },
      footer: {
        DefaultInformationFooterView(
          primaryButtonLabel: L10n.tkGlobalContinue,
          primaryButtonAction: viewModel.primaryAction)
      })
      .toolbar { toolbarContent() }
  }

  // MARK: Private

  private var viewModel: CheckCardIntroductionViewModel

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .topBarTrailing) {
      Button(action: viewModel.close, label: {
        Assets.close.swiftUIImage
      })
    }
  }
}

#Preview {
  CheckCardIntroductionView(router: EIDRequestRouter())
}
