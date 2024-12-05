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

  @Published var primaryText: String = L10n.onboardingPinCodeTitle
  @Published var secondaryText: String = L10n.onboardingPinCodeText
  let image: Image = Assets.lock.swiftUIImage
  let backgroundImage: Image = ThemingAssets.Gradient.gradient8.swiftUIImage
  let buttonLabelText: String = L10n.onboardingPinCodeEnterCodeButton

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
    primaryText = L10n.onboardingPinCodeTitle
    secondaryText = L10n.onboardingPinCodeText
  }

}

// MARK: PinCodeDelegate

extension PinCodeInformationViewModel: PinCodeDelegate {
  func didTryTooManyAttempts() {
    primaryText = L10n.onboardingPinCodeErrorTooManyAttemptsTitle
    secondaryText = L10n.onboardingPinCodeErrorTooManyAttemptsText
    hasTooManyAttemptsBeingTried = true
  }
}
