import BITL10n
import BITTheming
import Factory
import PopupView
import SwiftUI

struct NewPinCodeView: View {

  // MARK: Lifecycle

  init(_ router: ChangePinCodeInternalRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.newPinCodeViewModel(router))
  }

  // MARK: Internal

  var body: some View {
    PinCodeFormView(
      pinCode: $viewModel.pinCode,
      fieldTitle: L10n.tkGlobalNewpassword,
      inputFieldState: viewModel.inputFieldState,
      inputFieldMessage: viewModel.inputFieldMessage,
      isSubmitEnabled: viewModel.isSubmitEnabled,
      onPressNext: viewModel.submit)
      .navigationTitle(L10n.tkGlobalNewpassword)
      .popup(isPresented: $viewModel.isToastPresented) {
        Text(L10n.tkChangepasswordError4Notification)
          .font(.custom.footnote)
          .foregroundStyle(ThemingAssets.Brand.Bright.swissRedLabel.swiftUIColor)
          .padding(.horizontal, .x3)
          .padding(.vertical, .x2)
          .background(ThemingAssets.Brand.Bright.swissRed.swiftUIColor)
          .clipShape(.capsule)
          .padding(.bottom, 80)
      } customize: {
        $0
          .type(.floater())
          .position(.bottom)
          .autohideIn(3)
          .animation(.easeInOut)
      }
  }

  // MARK: Private

  @StateObject private var viewModel: NewPinCodeViewModel

}
