import BITVault
import Factory
import Foundation

// MARK: - LockWalletUseCase

struct LockWalletUseCase: LockWalletUseCaseProtocol {

  // MARK: Public

  func execute() throws {
    try repository.lockWallet()
  }

  // MARK: Private

  @Injected(\.lockWalletRepository) private var repository: LockWalletRepositoryProtocol
}

// MARK: - MockLockWalletUseCase

#if DEBUG || targetEnvironment(simulator)
struct MockLockWalletUseCase: LockWalletUseCaseProtocol {
  func execute() throws {}
}
#endif
