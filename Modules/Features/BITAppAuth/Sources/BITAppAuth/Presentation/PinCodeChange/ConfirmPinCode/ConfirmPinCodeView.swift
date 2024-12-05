import BITL10n
import Factory
import Foundation
import SwiftUI

struct ConfirmPinCodeView: View {

  init(_ router: ChangePinCodeInternalRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.confirmPinCodeViewModel(router))
  }

  var body: some View {
    ChangePinCodeFormView(
      pinCode: $viewModel.pinCode,
      fieldTitle: L10n.tkChangepasswordStep3Note1,
      inputFieldState: viewModel.inputFieldState,
      inputFieldMessage: viewModel.inputFieldMessage,
      attempts: viewModel.attempts,
      onPressNext: viewModel.submit)
      .navigationTitle(L10n.tkGlobalNewpassword)
  }

  @StateObject private var viewModel: ConfirmPinCodeViewModel

}
