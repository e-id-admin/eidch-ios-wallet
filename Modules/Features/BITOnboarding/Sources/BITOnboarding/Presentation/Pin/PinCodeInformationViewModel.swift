import BITL10n
import BITTheming
import Foundation
import SwiftUI

// MARK: - PinCodeInformationViewModel

class PinCodeInformationViewModel: ObservableObject {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    self.router = router
  }

  // MARK: Internal

  @Published var primaryText: String = L10n.tkOnboardingSecurewithcodeTitle
  @Published var secondaryText: String = L10n.tkOnboardingSecurewithcodeBody
  let image: Image = Assets.lock.swiftUIImage
  let backgroundImage: Image = ThemingAssets.Gradient.gradient8.swiftUIImage
  let buttonLabelText: String = L10n.tkOnboardingSecurewithcodePrimarybutton

  func nextOnboardingStep() {
    router.context.pinCodeDelegate = self
    router.pinCode()
  }

  func onAppear() {
    if hasTooManyAttemptsBeingTried {
      hasTooManyAttemptsBeingTried = false
      return
    }
    resetTexts()
  }

  // MARK: Private

  private var hasTooManyAttemptsBeingTried = false

  private let router: OnboardingInternalRoutes

  private func resetTexts() {
    secondaryText = L10n.tkOnboardingSecurewithcodeBody
  }

}

// MARK: PinCodeDelegate

extension PinCodeInformationViewModel: PinCodeDelegate {
  func didTryTooManyAttempts() {
    secondaryText = L10n.tkOnboardingPassworderrorBody
    hasTooManyAttemptsBeingTried = true
  }
}
