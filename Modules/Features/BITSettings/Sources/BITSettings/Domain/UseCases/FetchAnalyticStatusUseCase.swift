import Factory
import Foundation

struct FetchAnalyticStatusUseCase: FetchAnalyticStatusUseCaseProtocol {

  init(analyticsRepository: AnalyticsRepositoryProtocol = Container.shared.analyticsRepository()) {
    self.analyticsRepository = analyticsRepository
  }

  func execute() -> Bool {
    analyticsRepository.isAnalyticsAllowed()
  }

  private let analyticsRepository: AnalyticsRepositoryProtocol

}
