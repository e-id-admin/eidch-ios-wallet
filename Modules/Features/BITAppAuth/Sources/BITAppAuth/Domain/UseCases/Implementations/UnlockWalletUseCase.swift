import BITVault
import Factory
import Foundation

// MARK: - UnlockWalletUseCase

public struct UnlockWalletUseCase: UnlockWalletUseCaseProtocol {

  // MARK: Lifecycle

  init(repository: LockWalletRepositoryProtocol = Container.shared.lockWalletRepository()) {
    self.repository = repository
  }

  // MARK: Public

  public func execute() throws {
    try repository.unlockWallet()
  }

  // MARK: Private

  private let repository: LockWalletRepositoryProtocol
}
