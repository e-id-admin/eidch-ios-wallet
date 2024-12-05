import BITCore
import BITVault
import Factory
import Foundation
import Spyable

// MARK: - GetLockedWalletTimeLeftUseCase

struct GetLockedWalletTimeLeftUseCase: GetLockedWalletTimeLeftUseCaseProtocol {

  // MARK: Lifecycle

  init(
    lockDelay: TimeInterval = Container.shared.lockDelay(),
    repository: LockWalletRepositoryProtocol = Container.shared.lockWalletRepository(),
    processInfoService: ProcessInfoServiceProtocol = Container.shared.processInfoService())
  {
    self.lockDelay = lockDelay
    self.repository = repository
    self.processInfoService = processInfoService
  }

  // MARK: Internal

  func execute() -> TimeInterval? {
    guard let lockedTime = repository.getLockedWalletTimeInterval() else { return nil }
    let systemUptime = processInfoService.systemUptime
    let computedUnlockInterval = lockedTime + lockDelay
    return computedUnlockInterval - systemUptime
  }

  // MARK: Private

  private let repository: LockWalletRepositoryProtocol
  private let processInfoService: ProcessInfoServiceProtocol
  private let lockDelay: TimeInterval
}
