import CryptoKit
import Foundation

// MARK: - AESEncrypter

public struct AESEncrypter: Encryptable {

  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  public func encrypt(
    _ data: Data,
    withAsymmetricKey privateKey: SecKey,
    length: Int,
    derivationAlgorithm: SecKeyAlgorithm,
    initialVector: Data?) throws
    -> Data
  {
    guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
      throw EncrypterError.cannotRetrievePublicKey
    }
    guard
      let derivedKey = try SymmetricKeyUtils.deriveKeyPair(
        from: privateKey,
        and: publicKey,
        using: derivationAlgorithm,
        length: length) as? SymmetricKey else
    {
      throw EncrypterError.cannotDeriveKey
    }

    return try encrypt(data, withSymmetricKey: derivedKey, initialVector: initialVector)
  }

  public func encrypt(
    _ data: Data,
    withSymmetricKey key: SymmetricKeyProtocol,
    initialVector: Data?) throws
    -> Data
  {
    let nonce = Self.createNonce(considering: initialVector)
    guard let symmetricKey = key as? SymmetricKey else {
      throw EncrypterError.unexpectedSymmetricKey
    }

    guard let encryptedData = try AES.GCM.seal(data, using: symmetricKey, nonce: nonce).combined else {
      throw EncrypterError.cannotSeal
    }

    return encryptedData
  }
}

extension AESEncrypter {

  private static func createNonce(considering initialVector: Data?) -> AES.GCM.Nonce {
    (try? initialVector.map { try AES.GCM.Nonce(data: $0) }) ?? AES.GCM.Nonce()
  }

}
