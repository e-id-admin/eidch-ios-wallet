import Factory
import Foundation

struct IsBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol {

  func execute() -> Bool {
    do {
      return try repository.isBiometricUsageAllowed()
    } catch { return false }
  }

  @Injected(\.biometricRepository) private var repository: BiometricRepositoryProtocol

}
