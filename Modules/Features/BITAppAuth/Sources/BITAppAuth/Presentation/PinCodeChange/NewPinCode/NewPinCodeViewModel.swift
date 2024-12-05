import BITCore
import BITL10n
import Factory
import Foundation
import SwiftUI

// MARK: - NewPinCodeViewModel

class NewPinCodeViewModel: ObservableObject, Vibrating {

  // MARK: Lifecycle

  init(router: ChangePinCodeInternalRoutes) {
    self.router = router
    self.router.context.newPinCodeDelegate = self
  }

  // MARK: Internal

  var router: ChangePinCodeInternalRoutes

  @Published var inputFieldMessage: String?
  @Published var inputFieldState: InputFieldState = .normal
  @Published var isToastPresented: Bool = false

  @Published var pinCode: String = "" {
    didSet {
      guard userDidRequestValidation else { return }
      do {
        try validatePinCodeRuleUseCase.execute(pinCode)
        inputFieldState = .normal
        inputFieldMessage = nil
      } catch {
        handleError(error)
      }
    }
  }

  func submit() {
    do {
      userDidRequestValidation = true
      try validatePinCodeRuleUseCase.execute(pinCode)
      inputFieldState = .normal
      router.context.newPinCode = pinCode
      router.confirmNewPinCode()
    } catch {
      vibrate()
      handleError(error)
    }
  }

  // MARK: Private

  private var userDidRequestValidation: Bool = false

  @Injected(\.validatePinCodeRuleUseCase) private var validatePinCodeRuleUseCase: ValidatePinCodeRuleUseCaseProtocol

  private func handleError(_ error: Error) {
    withAnimation {
      inputFieldState = .error
      inputFieldMessage = error.localizedDescription
    }
  }

}

// MARK: NewPinCodeDelegate

extension NewPinCodeViewModel: NewPinCodeDelegate {
  func didFail() {
    withAnimation {
      isToastPresented = true
    }
  }
}
