import Factory
import Foundation

public struct UpdateAnalyticStatusUseCase: UpdateAnalyticStatusUseCaseProtocol {

  public init(analyticsRepository: AnalyticsRepositoryProtocol = Container.shared.analyticsRepository()) {
    self.analyticsRepository = analyticsRepository
  }

  public func execute(isAllowed: Bool) async {
    await analyticsRepository.allowAnalytics(isAllowed)
  }

  private let analyticsRepository: AnalyticsRepositoryProtocol
}
