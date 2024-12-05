import Factory
import Foundation

@MainActor
extension Container {

  var licencesViewModel: Factory<LicencesListViewModel> {
    self { LicencesListViewModel() }
  }

  var privacyViewModel: Factory<PrivacyViewModel> {
    self { PrivacyViewModel() }
  }
}

extension Container {

  // MARK: Public

  public var fetchPackagesUseCase: Factory<FetchPackagesUseCaseProtocol> {
    self { FetchPackagesUseCase(filePath: "package-list") }
  }

  public var analyticsRepository: Factory<AnalyticsRepositoryProtocol> {
    self { AnalyticsRepository() }
  }

  public var updateAnalyticsStatusUseCase: Factory<UpdateAnalyticStatusUseCaseProtocol> {
    self { UpdateAnalyticStatusUseCase() }
  }

  // MARK: Internal

  var fetchAnalyticStatusUseCase: Factory<FetchAnalyticStatusUseCaseProtocol> {
    self { FetchAnalyticStatusUseCase() }
  }

}
