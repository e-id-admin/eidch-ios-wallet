import Factory
import Foundation

// MARK: - AllowBiometricUsageUseCase

public struct AllowBiometricUsageUseCase: AllowBiometricUsageUseCaseProtocol {

  public func execute(allow: Bool) throws {
    try repository.allowBiometricUsage(allow)
  }

  @Injected(\.biometricRepository) private var repository: BiometricRepositoryProtocol

}
