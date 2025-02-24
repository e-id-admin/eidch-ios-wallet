import BITTheming
import Factory
import SwiftUI

// MARK: - CameraPermissionView

struct CameraPermissionView: View {

  // MARK: Lifecycle

  init(router: EIDRequestInternalRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.cameraPermissionViewModel(router))
  }

  // MARK: Internal

  @StateObject var viewModel: CameraPermissionViewModel

  var body: some View {
    InformationView(
      primary: viewModel.primary,
      secondary: viewModel.secondary,
      image: Assets.camera.swiftUIImage,
      backgroundColor: ThemingAssets.Background.secondary.swiftUIColor,
      primaryButtonLabel: viewModel.buttonText,
      primaryButtonAction: viewModel.buttonAction)
      .toolbar { toolbarContent() }
  }

  // MARK: Private

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .topBarTrailing) {
      Button(action: viewModel.close, label: {
        Assets.close.swiftUIImage
      })
      .accessibilitySortPriority(10)
    }
  }
}
