import Factory
import Foundation

public struct GetBuildNumberUseCase: GetBuildNumberUseCaseProtocol {

  private let repository: AppVersionRepositoryProtocol

  public init(repository: AppVersionRepositoryProtocol = Container.shared.appVersionRepository()) {
    self.repository = repository
  }

  public func execute() throws -> BuildNumber {
    try BuildNumber(repository.getBuildNumber())
  }

}
