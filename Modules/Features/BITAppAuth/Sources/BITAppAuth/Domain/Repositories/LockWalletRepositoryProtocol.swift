import Foundation
import Spyable

@Spyable
public protocol LockWalletRepositoryProtocol {
  func getLockedWalletTimeInterval() -> TimeInterval?
  func lockWallet() throws
  func unlockWallet() throws
}
