import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - PinCodeInformationView

struct PinCodeInformationView: View {

  init(router: OnboardingInternalRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.pinCodeInformationViewModel(router))
  }

  @StateObject var viewModel: PinCodeInformationViewModel

  var body: some View {
    InformationView(
      primary: viewModel.primaryText,
      secondary: viewModel.secondaryText,
      image: viewModel.image,
      backgroundImage: viewModel.backgroundImage,
      primaryButtonLabel: viewModel.buttonLabelText,
      primaryButtonAction: viewModel.nextOnboardingStep)
      .onAppear {
        viewModel.onAppear()
      }
  }
}
