import Foundation

// MARK: - UserDefaultHasDeletedCredentialRepository

struct UserDefaultHasDeletedCredentialRepository: HasDeletedCredentialRepositoryProtocol {
  private static let key = "hasDeletedCredential"

  public func setHasDeletedCredential() {
    UserDefaults.standard.set(true, forKey: Self.key)
  }

  func hasDeletedCredential() -> Bool {
    UserDefaults.standard.bool(forKey: Self.key)
  }
}
