import BITVault
import Factory
import Foundation

// MARK: - LockWalletUseCase

struct LockWalletUseCase: LockWalletUseCaseProtocol {

  // MARK: Lifecycle

  init(repository: LockWalletRepositoryProtocol = Container.shared.lockWalletRepository()) {
    self.repository = repository
  }

  // MARK: Public

  func execute() throws {
    try repository.lockWallet()
  }

  // MARK: Private

  private let repository: LockWalletRepositoryProtocol
}

// MARK: - MockLockWalletUseCase

#if DEBUG || targetEnvironment(simulator)
struct MockLockWalletUseCase: LockWalletUseCaseProtocol {
  func execute() throws {}
}
#endif
