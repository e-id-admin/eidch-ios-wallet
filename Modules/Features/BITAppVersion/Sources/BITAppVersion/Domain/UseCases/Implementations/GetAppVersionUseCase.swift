import Factory
import Foundation

public struct GetAppVersionUseCase: GetAppVersionUseCaseProtocol {

  private let repository: AppVersionRepositoryProtocol

  public init(repository: AppVersionRepositoryProtocol = Container.shared.appVersionRepository()) {
    self.repository = repository
  }

  public func execute() throws -> AppVersion {
    try AppVersion(repository.getVersion())
  }

}
