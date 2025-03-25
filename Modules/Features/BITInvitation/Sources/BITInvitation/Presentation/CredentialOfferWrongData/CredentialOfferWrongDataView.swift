import BITL10n
import BITTheming
import Factory
import SwiftUI

// MARK: - CredentialOfferWrongDataView

struct CredentialOfferWrongDataView: View {

  // MARK: Lifecycle

  init(router: CredentialOfferInternalRoutes) {
    viewModel = Container.shared.credentialOfferWrongDataViewModel(router)
  }

  // MARK: Internal

  var body: some View {
    InformationView(
      image: Assets.xmarkCircle.swiftUIImage,
      backgroundColor: ThemingAssets.Background.system.swiftUIColor,
      content: {
        DefaultInformationContentView(
          primary: L10n.tkReceiveIncorrectdataSubtitle,
          secondary: L10n.tkReceiveIncorrectdataBody)
      })
      .navigationTitle(L10n.tkReceiveIncorrectdataTitle)
      .toolbar(content: toolbarContent)
      .ignoresSafeArea(edges: .bottom)
  }

  // MARK: Private

  private var viewModel: CredentialOfferWrongDataViewModel

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Button(action: viewModel.close, label: {
        Assets.close.swiftUIImage
      })
    }
  }
}

#if DEBUG
#Preview {
  CredentialOfferWrongDataView(router: CredentialOfferRouter())
}
#endif
