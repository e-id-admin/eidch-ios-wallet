import Foundation

// MARK: - VaultAlgorithm

public enum VaultAlgorithm: String, CaseIterable {
  case eciesEncryptionStandardVariableIVX963SHA256AESGCM = "ES256"
  case eciesEncryptionStandardVariableIVX963SHA512AESGCM = "ES512"

  // MARK: Lifecycle

  public init(fromSignatureAlgorithm signatureAlgorithm: String) throws {
    for algorithm in VaultAlgorithm.allCases where signatureAlgorithm.uppercased() == algorithm.rawValue {
      self = algorithm
      return
    }
    throw VaultError.algorithmNotSupported
  }

  // MARK: Public

  public var keyType: CFString {
    switch self {
    case .eciesEncryptionStandardVariableIVX963SHA256AESGCM:
      kSecAttrKeyTypeECSECPrimeRandom
    case .eciesEncryptionStandardVariableIVX963SHA512AESGCM:
      kSecAttrKeyTypeECSECPrimeRandom
    }
  }

  public var canBeUsedForSecureEnclave: Bool {
    self == .eciesEncryptionStandardVariableIVX963SHA256AESGCM
  }

  public var encryptionAlgorithm: SecKeyAlgorithm {
    switch self {
    case .eciesEncryptionStandardVariableIVX963SHA256AESGCM:
      .eciesEncryptionStandardVariableIVX963SHA256AESGCM
    case .eciesEncryptionStandardVariableIVX963SHA512AESGCM:
      .eciesEncryptionStandardVariableIVX963SHA512AESGCM
    }
  }

  public var signingAlgorithm: SecKeyAlgorithm {
    switch self {
    case .eciesEncryptionStandardVariableIVX963SHA256AESGCM:
      .ecdsaSignatureMessageX962SHA256
    case .eciesEncryptionStandardVariableIVX963SHA512AESGCM:
      .eciesEncryptionStandardVariableIVX963SHA512AESGCM
    }
  }

  public var size: Int {
    switch self {
    case .eciesEncryptionStandardVariableIVX963SHA256AESGCM: 256
    case .eciesEncryptionStandardVariableIVX963SHA512AESGCM: 521
    }
  }

}
