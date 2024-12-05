import BITVault
import Factory
import Foundation

struct LoginRepository: LoginRepositoryProtocol {

  // MARK: Lifecycle

  init(secretManager: SecretManagerProtocol = Container.shared.secretManager()) {
    self.secretManager = secretManager
  }

  // MARK: Internal

  @discardableResult
  func registerAttempt(_ number: Int, kind: AuthMethod) throws -> Int {
    try secretManager.set(number, forKey: kind.attemptKey)
    return number
  }

  func getAttempts(kind: AuthMethod) throws -> Int {
    secretManager.integer(forKey: kind.attemptKey) ?? 0
  }

  func resetAttempts(kind: AuthMethod) throws {
    try secretManager.removeObject(forKey: kind.attemptKey)
  }

  // MARK: Private

  private let secretManager: SecretManagerProtocol

}
