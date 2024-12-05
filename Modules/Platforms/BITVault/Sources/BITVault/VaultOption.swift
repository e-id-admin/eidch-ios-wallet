import Foundation

// MARK: - VaultOption

public struct VaultOption: OptionSet {

  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }

  public let rawValue: UInt8

  public static let secureEnclave = VaultOption(rawValue: 1 << 0)
  public static let savePermanently = VaultOption(rawValue: 1 << 1)

  public static let secureEnclavePermanently: VaultOption = [.secureEnclave, .savePermanently]
  public static let none: VaultOption = []
}
