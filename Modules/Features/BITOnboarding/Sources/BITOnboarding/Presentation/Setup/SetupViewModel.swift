import BITAppAuth
import Combine
import Factory
import Foundation
import SwiftUI

// MARK: - SetupViewModel

@MainActor
class SetupViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    router: OnboardingInternalRoutes,
    registerPinCodeUseCase: RegisterPinCodeUseCaseProtocol = Container.shared.registerPinCodeUseCase())
  {
    self.router = router
    self.registerPinCodeUseCase = registerPinCodeUseCase
  }

  // MARK: Internal

  @AppStorage("rootOnboardingIsEnabled") var isOnboardingEnabled: Bool = true

  @Published var isAnimating: Bool = true

  func run() async {
    do {
      withAnimation {
        isAnimating = true
      }
      try await Task.sleep(nanoseconds: 2_000_000_000)
      guard let pincode = router.context.pincode else { throw SetupError.missingPinCode }
      try registerPinCodeUseCase.execute(pinCode: pincode)
      isOnboardingEnabled = false
      try await Task.sleep(nanoseconds: 2_000_000_000)
      router.completed()
    } catch {
      isAnimating = false
      router.setupError(delegate: self)
    }
  }

  // MARK: Private

  private enum SetupError: Error {
    case missingPinCode
  }

  private let router: OnboardingInternalRoutes
  private var registerPinCodeUseCase: RegisterPinCodeUseCaseProtocol

}

// MARK: SetupDelegate

extension SetupViewModel: SetupDelegate {

  func restartSetup() {
    Task { await run() }
  }

}

// MARK: - SetupDelegate

protocol SetupDelegate: AnyObject {
  func restartSetup()
}
