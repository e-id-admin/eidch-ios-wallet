import BITL10n
import BITTheming
import Factory
import PopupView
import SwiftUI

// MARK: - DeeplinkLoadingView

struct DeeplinkLoadingView: View {

  // MARK: Lifecycle

  init(url: URL, router: InvitationRouterRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.deeplinkViewModel((url, router)))
  }

  // MARK: Internal

  @StateObject var viewModel: DeeplinkViewModel

  var body: some View {
    ZStack {
      Rectangle()
        .overlay(
          ThemingAssets.Gradient.gradient4.swiftUIImage
            .resizable()
            .scaledToFill()
            .clipped()
        )
        .clipped()
        .ignoresSafeArea()
        .accessibilityHidden(true)

      ThemingAssets.Gradient.gradient2.swiftUIImage
        .resizable()
        .frame(maxWidth: Defaults.innerGradientMaxWidth, maxHeight: Defaults.innerGradientMaxHeight)
        .clipShape(.rect(cornerRadius: .CornerRadius.l))

      if viewModel.isLoading {
        progressView()
      }

      if let invitationError = viewModel.qrScannerError as? DeeplinkViewModel.CameraError {
        errorView(invitationError)
      }
    }
  }

  // MARK: Private

  private enum Defaults {
    static let innerGradientMaxWidth = 250.0
    static let innerGradientMaxHeight = 462.0
  }
}

// MARK: - Components

extension DeeplinkLoadingView {

  @ViewBuilder
  private func progressView() -> some View {
    ProgressView()
      .tint(.white)
      .scaleEffect(1.5)
  }

  @ViewBuilder
  private func errorView(_ error: DeeplinkViewModel.CameraError) -> some View {
    VStack(spacing: .x2) {
      Spacer()
      Text(error.primaryText)
        .font(.custom.title)
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .accessibilityLabel(error.primaryText)

      Text(error.secondaryText)
        .font(.custom.body)
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .accessibilityLabel(error.secondaryText)

      Spacer()
      Button(L10n.globalBack, action: viewModel.close)
        .padding(.bottom, .x2)
        .controlSize(.large)
        .buttonStyle(.filledPrimary)
        .accessibilityLabel(L10n.globalBack)
    }
    .padding(.horizontal, .x6)
  }
}
