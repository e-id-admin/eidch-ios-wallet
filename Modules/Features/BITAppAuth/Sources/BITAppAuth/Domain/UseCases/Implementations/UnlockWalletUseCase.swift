import BITVault
import Factory
import Foundation

// MARK: - UnlockWalletUseCase

public struct UnlockWalletUseCase: UnlockWalletUseCaseProtocol {

  // MARK: Public

  public func execute() throws {
    try repository.unlockWallet()
  }

  // MARK: Private

  @Injected(\.lockWalletRepository) private var repository: LockWalletRepositoryProtocol
}
