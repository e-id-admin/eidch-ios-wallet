import BITAnyCredentialFormat
import BITCrypto
import Foundation

// MARK: - CredentialWithKeyBinding

public struct CredentialWithKeyBinding {

  // MARK: Lifecycle

  public init(anyCredential: AnyCredential, boundTo keyPair: KeyPair?) {
    self.anyCredential = anyCredential
    self.keyPair = keyPair
  }

  // MARK: Public

  public let anyCredential: AnyCredential

  public let keyPair: KeyPair?

}
