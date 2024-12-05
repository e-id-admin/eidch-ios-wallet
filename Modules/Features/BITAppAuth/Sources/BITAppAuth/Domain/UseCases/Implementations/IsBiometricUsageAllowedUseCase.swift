import Factory
import Foundation

struct IsBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol {

  let repository: BiometricRepositoryProtocol

  init(repository: BiometricRepositoryProtocol = Container.shared.biometricRepository()) {
    self.repository = repository
  }

  func execute() -> Bool {
    do {
      return try repository.isBiometricUsageAllowed()
    } catch { return false }
  }

}
