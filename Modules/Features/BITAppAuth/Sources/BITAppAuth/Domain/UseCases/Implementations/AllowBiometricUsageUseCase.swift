import Factory
import Foundation

// MARK: - AllowBiometricUsageUseCase

public struct AllowBiometricUsageUseCase: AllowBiometricUsageUseCaseProtocol {

  let repository: BiometricRepositoryProtocol

  public init(repository: BiometricRepositoryProtocol = Container.shared.biometricRepository()) {
    self.repository = repository
  }

  public func execute(allow: Bool) throws {
    try repository.allowBiometricUsage(allow)
  }

}
