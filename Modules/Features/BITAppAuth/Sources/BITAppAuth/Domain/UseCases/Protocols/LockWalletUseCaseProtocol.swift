import Foundation
import Spyable

// MARK: - LockWalletUseCaseProtocol

@Spyable
public protocol LockWalletUseCaseProtocol {
  func execute() throws
}
