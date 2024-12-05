import CryptoKit
import Foundation

// MARK: - SymmetricKeyUtils

struct SymmetricKeyUtils {

  /// Derive a symmetric key from the two given given as input
  /// - Parameters:
  ///   - keyPair: The KeyPair on which the symmetric key is derived
  ///   - secKeyAlgorithm: The algorithm to use for the derivation
  ///   - length:The lenght in bytes of the derived key
  static func deriveKeyPair(
    from key1: SecKey,
    and key2: SecKey,
    using secKeyAlgorithm: SecKeyAlgorithm,
    length: Int) throws
    -> SymmetricKeyProtocol
  {
    var derivationError: Unmanaged<CFError>?
    let parameters: [String: Any] = [
      SecKeyKeyExchangeParameter.requestedSize.rawValue as String: length,
    ]
    guard
      let sharedSecret = SecKeyCopyKeyExchangeResult(
        key1,
        secKeyAlgorithm,
        key2,
        parameters as CFDictionary,
        &derivationError) else
    {
      throw EncrypterError.cannotCopyKeyExchangeResult(errorDerive: derivationError)
    }
    let derivedData = sharedSecret as Data
    return SymmetricKey(data: derivedData.prefix(length))
  }

}
