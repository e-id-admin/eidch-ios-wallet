import BITAnalytics
import BITL10n
import BITSettings
import Factory
import Foundation
import SwiftUI

@MainActor
class PrivacyPermissionViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    router: OnboardingInternalRoutes,
    updateAnalyticsStatusUseCase: UpdateAnalyticStatusUseCaseProtocol = Container.shared.updateAnalyticsStatusUseCase())
  {
    self.router = router
    self.updateAnalyticsStatusUseCase = updateAnalyticsStatusUseCase
  }

  // MARK: Internal

  @Published var isLoading: Bool = false

  func updatePrivacyPolicy(to value: Bool) async {
    withAnimation {
      isLoading = true
    }

    await updateAnalyticsStatusUseCase.execute(isAllowed: value)
    router.pinCodeInformation()

    withAnimation {
      isLoading = false
    }
  }

  func openPrivacyPolicy() {
    guard let url = URL(string: L10n.onboardingPrivacyLinkValue) else { return }
    router.openExternalLink(url: url)
  }

  // MARK: Private

  private let router: OnboardingInternalRoutes
  private let updateAnalyticsStatusUseCase: UpdateAnalyticStatusUseCaseProtocol

}
