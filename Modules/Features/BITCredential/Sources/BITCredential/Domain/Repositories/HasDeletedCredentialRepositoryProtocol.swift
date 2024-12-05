import Foundation
import Spyable

// MARK: - HasDeletedCredentialRepositoryProtocol

@Spyable
public protocol HasDeletedCredentialRepositoryProtocol {
  func setHasDeletedCredential()
  func hasDeletedCredential() -> Bool
}
