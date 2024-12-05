import BITL10n
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - BiometricChangeFlowView

public struct BiometricChangeFlowView: View {

  // MARK: Lifecycle

  public init(isPresented: Binding<Bool>, isBiometricEnabled: Bool) {
    _viewModel = StateObject(wrappedValue: Container.shared.biometricChangeFlowViewModel((isPresented, isBiometricEnabled)))
  }

  // MARK: Public

  public var body: some View {
    content()
      .padding(.top, .x5)
      .clipped()
      .navigationTitle(L10n.changeBiometricsTitle)
      .navigationBackButtonDisplayMode(.minimal)
  }

  // MARK: Internal

  @StateObject var viewModel: BiometricChangeFlowViewModel

  var pinCodeViewText: String {
    viewModel.isBiometricEnabled ? L10n.changeBiometricsPinDeactivationContentText : L10n.changeBiometricsPinActivationContentText
  }

  // MARK: Private

  @ViewBuilder
  private func content() -> some View {
    VStack(alignment: .leading) {
      Pager(pageCount: BiometricChangeStep.allCases.count, currentIndex: $viewModel.currentIndex, isSwipeEnabled: .constant(false)) {
        BiometricChangeSettingsView(type: BiometricType(type: viewModel.biometricType))
        pinCodeView(title: L10n.biometricSetupTitle(viewModel.biometricType.text), pinCode: $viewModel.pinCode, state: viewModel.pinCodeState, text: pinCodeViewText)
      }
    }.onAppear {
      viewModel.viewDidAppear()
    }
  }

  @ViewBuilder
  private func pinCodeView(title: String, pinCode: Binding<String>, state: PinCodeState, text: String) -> some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.custom.title)
    }
    .padding(.horizontal, .x4)
  }

}
