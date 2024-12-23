import BITL10n
import BITTheming
import Factory
import SwiftUI

struct BiometricChangeView: View {

  // MARK: Lifecycle

  init(_ router: BiometricChangeRouterRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.biometricChangeViewModel(router))
  }

  // MARK: Internal

  var body: some View {
    content()
      .onAppear { viewModel.onAppear() }
      .navigationTitle(viewModel.title)
  }

  // MARK: Private

  @Environment(\.colorScheme) private var colorScheme

  @StateObject private var viewModel: BiometricChangeViewModel

  @ViewBuilder
  private func content() -> some View {
    switch viewModel.state {
    case .password:
      passwordView()
    case .disabledBiometrics:
      disabledBiometricsView()
    }
  }

  @ViewBuilder
  private func passwordView() -> some View {
    PinCodeFormView(
      pinCode: $viewModel.pinCode,
      fieldTitle: L10n.tkLoginPasswordBody,
      inputFieldState: viewModel.inputFieldState,
      inputFieldMessage: viewModel.inputFieldMessage,
      attempts: viewModel.attempts,
      onPressNext: {
        Task {
          await viewModel.submit()
        }
      })
  }

  @ViewBuilder
  private func disabledBiometricsView() -> some View {
    InformationView(
      primary: L10n.biometricSetupTitle(viewModel.biometricType.text),
      secondary: L10n.biometricSetupContent(viewModel.biometricType.text),
      image: viewModel.biometricType.image,
      backgroundColor: ThemingAssets.Background.secondary.swiftUIColor,
      buttonLabel: L10n.biometricSetupNoClass3ToSettingsButton,
      onNextAction: {
        viewModel.openSettings()
      })
  }

}
