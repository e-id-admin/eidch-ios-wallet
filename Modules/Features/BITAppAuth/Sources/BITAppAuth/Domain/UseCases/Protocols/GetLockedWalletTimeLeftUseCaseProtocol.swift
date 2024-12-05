import Foundation
import Spyable

// MARK: - GetLockedWalletTimeLeftUseCaseProtocol

@Spyable
public protocol GetLockedWalletTimeLeftUseCaseProtocol {
  func execute() -> TimeInterval?
}
