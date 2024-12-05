import BITL10n
import BITTheming
import Factory
import SwiftUI

// MARK: - CredentialWrongDataView

struct CredentialWrongDataView: View {

  // MARK: Lifecycle

  init(router: CredentialWrongDataRouterRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.credentialWrongDataViewModel(router))
  }

  // MARK: Internal

  var body: some View {
    InformationView(
      primary: L10n.tkReceiveIncorrectdataSubtitle,
      secondary: L10n.tkReceiveIncorrectdataBody,
      tertiary: L10n.tkReceiveIncorrectdataLinkText,
      tertiaryAction: viewModel.openInformations,
      isTertiaryTapable: true,
      image: Assets.xmarkCircle.swiftUIImage,
      backgroundColor: ThemingAssets.Background.system.swiftUIColor)
      .navigationTitle(L10n.tkReceiveIncorrectdataTitle)
      .toolbar(content: toolbarContent)
      .ignoresSafeArea(edges: .bottom)
  }

  // MARK: Private

  @StateObject private var viewModel: CredentialWrongDataViewModel

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Button(action: viewModel.close, label: {
        Assets.closeAlt.swiftUIImage
      })
    }
  }
}

#if DEBUG
#Preview {
  CredentialWrongDataView(router: CredentialWrongDataRouter())
}
#endif
