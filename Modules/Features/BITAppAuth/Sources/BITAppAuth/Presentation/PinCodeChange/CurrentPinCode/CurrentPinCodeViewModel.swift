import BITCore
import BITL10n
import Combine
import Factory
import Foundation
import SwiftUI

@MainActor
class CurrentPinCodeViewModel: ObservableObject, Vibrating {

  // MARK: Lifecycle

  init(router: ChangePinCodeInternalRoutes) {
    self.router = router

    evaluateAttempts()
  }

  // MARK: Internal

  var router: ChangePinCodeInternalRoutes

  @Published var inputFieldMessage: String?
  @Published var attempts: Int = 0
  @Published var inputFieldState: InputFieldState = .normal

  @Published var pinCode: String = "" {
    didSet {
      guard userDidRequestValidation else { return }
      inputFieldState = .normal
    }
  }

  func submit() {
    do {
      userDidRequestValidation = true
      router.context.uniquePassphrase = try getUniquePassphraseUseCase.execute(from: pinCode)
      reset()
      router.newPinCode()
    } catch {
      handleError(error)
    }
  }

  func onAppear() {
    evaluateAttempts()
  }

  // MARK: Private

  private var userDidRequestValidation: Bool = false
  private var bag: Set<AnyCancellable> = []

  @Injected(\.getUniquePassphraseUseCase) private var getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol
  @Injected(\.lockWalletUseCase) private var lockWalletUseCase: LockWalletUseCaseProtocol
  @Injected(\.registerLoginAttemptCounterUseCase) private var registerLoginAttemptCounterUseCase: RegisterLoginAttemptCounterUseCaseProtocol
  @Injected(\.getLoginAttemptCounterUseCase) private var getLoginAttemptCounterUseCase: GetLoginAttemptCounterUseCaseProtocol
  @Injected(\.resetLoginAttemptCounterUseCase) private var resetLoginAttemptCounterUseCase: ResetLoginAttemptCounterUseCaseProtocol
  @Injected(\.attemptsLimit) private var attemptsLimit: Int

  private var attemptLeft: Int { attemptsLimit - attempts }

  private func reset() {
    try? resetLoginAttemptCounterUseCase.execute()
    inputFieldMessage = nil
    attempts = 0
  }

  private func evaluateAttempts() {
    attempts = (try? getLoginAttemptCounterUseCase.execute(kind: .appPin)) ?? 0

    var message: String? = nil
    if attemptLeft < attemptsLimit {
      message = L10n.tkChangepasswordError1IosNote2(attemptLeft)
    }

    withAnimation {
      if message == nil {
        inputFieldState = .normal
      }
      inputFieldMessage = message
    }
  }

  private func handleError(_ error: Error) {
    inputFieldState = .error
    attempts = (try? registerLoginAttemptCounterUseCase.execute(kind: .appPin)) ?? attempts + 1

    if attempts >= attemptsLimit {
      return lockWallet()
    }

    let message = L10n.tkChangepasswordError1IosNote2(attemptLeft)
    withAnimation {
      vibrate()
      inputFieldMessage = message
    }
  }

  private func lockWallet() {
    try? lockWalletUseCase.execute()
    NotificationCenter.default.post(name: .logout, object: nil)
  }

}
