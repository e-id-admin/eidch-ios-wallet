import Foundation
import Spyable

/// A protocol for key derivation functions (KDFs), designed to securely derive cryptographic keys from a given password and salt.
@Spyable
public protocol KeyDerivable {

  /// Derives a cryptographic key from the given password data and salt.
  ///
  /// - Parameters:
  ///   - data: The input data from which to derive the key.
  ///   - salt: A unique salt used to make each derived key distinct, increasing security.
  /// - Throws: An error if the key derivation process fails.
  /// - Returns: A derived key as `Data`, suitable for use in cryptographic operations.
  func deriveKey(from data: Data, with salt: Data) throws -> Data

}
