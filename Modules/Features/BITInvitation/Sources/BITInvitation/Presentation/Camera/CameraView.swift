import BITL10n
import BITQRScanner
import BITTheming
import Factory
import PopupView
import SwiftUI

// MARK: - CameraView

struct CameraView: View {

  // MARK: Lifecycle

  init(router: InvitationRouterRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.cameraViewModel(router))
  }

  // MARK: Internal

  var body: some View {
    content()
      .onAppear {
        UIAccessibility.post(notification: .screenChanged, argument: L10n.tkQrscannerScanningTitle)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          focus = .camera
        }
      }
      .popup(isPresented: $viewModel.isTorchEnabled) {
        torchTipView()
      } customize: {
        $0.type(.floater())
          .closeOnTap(false)
          .appearFrom(.bottomSlide)
          .dismissCallback {
            focus = .flashlight
          }
      }
      .popup(isPresented: $viewModel.isTipPresented) {
        if orientation.isPortrait {
          helpTipView()
        } else {
          HStack {
            Spacer()
            helpTipView()
          }
        }
      } customize: {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          focus = .tip
        }
        return $0.type(.floater())
          .appearFrom(.bottomSlide)
          .dismissCallback {
            focus = .camera
          }
      }
      .popup(isPresented: $viewModel.isLoading) {
        progressView()
      } customize: {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          focus = .loadingTip
        }
        return $0.type(.floater())
          .appearFrom(.centerScale)
          .position(.center)
      }
      .popup(isPresented: $viewModel.isPopupErrorPresented) {
        if let invitationError = viewModel.qrScannerError as? CameraViewModel.CameraError {
          if orientation.isPortrait {
            errorView(invitationError)
          } else {
            HStack {
              Spacer()
              errorView(invitationError)
            }
          }
        }
      } customize: {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          focus = .tip
        }
        return $0.type(.floater())
          .appearFrom(.bottomSlide)
          .autohideIn(voiceOverEnabled ? nil : 7)
          .dismissCallback {
            focus = .camera
          }
      }
      .task {
        await viewModel.onAppear()
      }
      .animation(.default, value: viewModel.isLoading)
      .navigationBarBackButtonHidden()
      .toolbar { toolbarContent() }
      .accessibilityElement(children: .contain)
      .environment(\.colorScheme, .light)
  }

  // MARK: Private

  private enum Constants {
    static let tipViewMaxWidth: CGFloat = 350
  }

  private enum FocusableElement {
    case tip, close, flashlight, camera, flashlightTip, loadingTip
  }

  @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

  @AccessibilityFocusState private var focus: FocusableElement?
  @StateObject private var viewModel: CameraViewModel

  @Orientation private var orientation

  @ViewBuilder
  private func content() -> some View {
    ZStack(alignment: .bottom) {
      ThemingAssets.Brand.Core.navyBlue.swiftUIColor
      scannerView()
    }
    .ignoresSafeArea(edges: orientation.isLandscape ? [.leading, .trailing] : [])
  }

}

// MARK: - Components

extension CameraView {
  @ViewBuilder
  private func scannerView() -> some View {
    CameraPreview(session: viewModel.session, object: viewModel.cameraManager.capturedObject, viewModel.didMoveFocusArea(to:))
      .clipShape(RoundedCorner(radius: .x6, corners: [.topLeft, .topRight]))
      .padding(.top, .x5)
      .ignoresSafeArea(edges: [.bottom])
      .accessibilityLabel(L10n.tkQrscannerScanningTitle)
      .accessibilityElement(children: .contain)
      .accessibilitySortPriority(100)
      .accessibilityFocused($focus, equals: .camera)
  }

  @ViewBuilder
  private func progressView() -> some View {
    ProgressViewLabelBadge(
      text: L10n.cameraQrcodeScannerLoader,
      background: ThemingAssets.Background.tertiary.swiftUIColor,
      foreground: ThemingAssets.Label.primary.swiftUIColor)
      .accessibilityFocused($focus, equals: .loadingTip)
  }

  @ViewBuilder
  private func torchTipView() -> some View {
    LabelBadge(text: L10n.cameraQrcodeLight, backgroundColor: ThemingAssets.Brand.Bright.navyBlue.swiftUIColor, image: "sun.min")
  }

  @ViewBuilder
  private func helpTipView() -> some View {
    tipView(primary: L10n.cameraQrcodeScannerPrimary, secondary: L10n.cameraQrcodeScannerSecondary, icon: Assets.qrcode.swiftUIImage, close: viewModel.closeTipView)
      .frame(maxWidth: orientation.isPortrait ? .infinity : Constants.tipViewMaxWidth)
      .padding(.horizontal, orientation.isPortrait ? .x3 : .x1)
  }

  @ViewBuilder
  private func errorView(_ error: CameraViewModel.CameraError) -> some View {
    tipView(primary: error.primaryText, secondary: error.secondaryText, icon: error.icon, close: viewModel.closeErrorView)
      .frame(maxWidth: orientation.isPortrait ? .infinity : Constants.tipViewMaxWidth)
      .padding(.horizontal, orientation.isPortrait ? .x3 : .x1)
  }

  @ViewBuilder
  private func tipView(primary: String, secondary: String, tertiary: String? = nil, icon: Image, close: @escaping() -> Void) -> some View {
    Notification(
      image: icon,
      imageColor: ThemingAssets.Label.primary.swiftUIColor,
      title: primary,
      titleColor: ThemingAssets.Label.primary.swiftUIColor,
      content: secondary,
      contentColor: ThemingAssets.Label.secondary.swiftUIColor,
      closeAction: close,
      background: ThemingAssets.Background.tertiary.swiftUIColor,
      closeButtonStyle: .bezeledLight)
      .accessibilityFocused($focus, equals: .tip)
  }

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Button(action: { viewModel.toggleTorch() }, label: {
        viewModel.isTorchEnabled ? Assets.lightOn.swiftUIImage : Assets.lightOff.swiftUIImage
      })
      .accessibilityLabel(viewModel.isTorchEnabled ? L10n.tkQrscannerLightonLabel : L10n.tkQrscannerLightoffLabel)
      .accessibilitySortPriority(20)
      .accessibilityFocused($focus, equals: .flashlight)
    }

    ToolbarItem(placement: .topBarTrailing) {
      Button(action: viewModel.close, label: {
        Assets.close.swiftUIImage
          .environment(\.colorScheme, .dark)
      })
      .accessibilitySortPriority(10)
      .accessibilityFocused($focus, equals: .close)
    }
  }
}
