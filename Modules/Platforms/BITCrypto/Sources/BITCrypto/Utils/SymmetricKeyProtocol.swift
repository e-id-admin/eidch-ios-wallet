import CryptoKit
import Foundation

// MARK: - SymmetricKeyProtocol

public protocol SymmetricKeyProtocol {}

// MARK: - SymmetricKey + SymmetricKeyProtocol

extension SymmetricKey: SymmetricKeyProtocol {}
