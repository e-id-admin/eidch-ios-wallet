import Foundation
import Spyable

// MARK: - Encryptable

/// A protocol for secure encryption and decryption of data, designed to provide confidentiality through symmetric encryption algorithms.
@Spyable
public protocol Encryptable {

  /// Produce a cipher of the data given in parameter.
  /// For an asymmetric key, a derivation must be made considering the algorithm given in parameter.
  /// This is because encryption are working with symmetric keys.
  /// - Parameters:
  ///   - data: The data to to encrypt
  ///   - privateKey: The asymmetricKey to be derived for the encryption
  ///   - length: Length In bytes
  ///   - derivationAlgorithm: The derivation algorithm to be used for the asymmetric key given in parameter
  ///   - initialVector: initialVector to take in consideration for the encryption. Can be nil.
  ///   - Returns: The cipher of the input data
  func encrypt(
    _ data: Data,
    withAsymmetricKey privateKey: SecKey,
    length: Int,
    derivationAlgorithm: SecKeyAlgorithm,
    initialVector: Data?) throws
    -> Data

  /// Produce a cipher of the data given in parameter.
  /// - Parameters:
  ///   - data: The data to to encrypt
  ///   - Returns: The cipher of the input data
  func encrypt(
    _ data: Data,
    withSymmetricKey key: SymmetricKeyProtocol,
    initialVector: Data?) throws
    -> Data

}

// MARK: - EncrypterError

enum EncrypterError: Error {
  case cannotRetrievePublicKey
  case cannotCopyKeyExchangeResult(errorDerive: Unmanaged<CFError>?)
  case cannotDeriveKey
  case unexpectedSymmetricKey
  case cannotSeal
}
