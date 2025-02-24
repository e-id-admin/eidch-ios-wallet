import CryptoSwift
import Factory
import Foundation

// MARK: - PBKDF2

public struct PBKDF2: KeyDerivable {

  // MARK: Lifecycle

  public init(
    using variant: Variant,
    configuration: Configuration = Container.shared.pbkdf2Configuration())
  {
    self.variant = variant
    self.configuration = configuration
  }

  // MARK: Public

  public func deriveKey(from data: Data, with salt: Data) throws -> Data {
    let key = try PKCS5.PBKDF2(
      password: [UInt8](data),
      salt: [UInt8](salt),
      iterations: configuration.iterations,
      keyLength: configuration.keyLength,
      variant: variant.hmacVariant())
    return try Data(key.calculate())
  }

  // MARK: Private

  private let variant: Variant
  private let configuration: Configuration
}

// MARK: PBKDF2.Configuration

extension PBKDF2 {
  public struct Configuration {
    let iterations: Int
    let keyLength: Int
  }

  public enum Variant {
    case hmacSHA256
    case hmacSHA512

    fileprivate func hmacVariant() -> HMAC.Variant {
      switch self {
      case .hmacSHA256: .sha2(.sha256)
      case .hmacSHA512: .sha2(.sha512)
      }
    }
  }
}
