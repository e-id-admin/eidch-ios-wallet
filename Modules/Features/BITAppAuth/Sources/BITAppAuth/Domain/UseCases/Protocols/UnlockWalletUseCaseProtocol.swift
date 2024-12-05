import Foundation
import Spyable

// MARK: - UnlockWalletUseCaseProtocol

@Spyable
public protocol UnlockWalletUseCaseProtocol {
  func execute() throws
}
