import BITAppAuth
import BITSettings
import Combine
import Factory
import Foundation
import SwiftUI

// MARK: - SetupViewModel

@MainActor
class SetupViewModel: ObservableObject {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    self.router = router
  }

  // MARK: Internal

  @AppStorage("rootOnboardingIsEnabled") var isOnboardingEnabled = true

  @Published var isAnimating = true

  func run() async {
    do {
      withAnimation {
        isAnimating = true
      }
      try await Task.sleep(nanoseconds: 2_000_000_000)
      guard let pincode = router.context.pincode else { throw SetupError.missingPinCode }
      try registerPinCodeUseCase.execute(pinCode: pincode)
      await updateAnalyticsStatusUseCase.execute(isAllowed: router.context.analyticsOptIn)
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
  @Injected(\.registerPinCodeUseCase) private var registerPinCodeUseCase: RegisterPinCodeUseCaseProtocol
  @Injected(\.updateAnalyticsStatusUseCase) private var updateAnalyticsStatusUseCase: UpdateAnalyticStatusUseCaseProtocol

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
