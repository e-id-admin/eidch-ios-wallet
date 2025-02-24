import Foundation

public struct UserDefaultBiometricRepository: BiometricRepositoryProtocol {

  public init() {}

  let key = "isBiometricUsageAllowed"

  public func allowBiometricUsage(_ allow: Bool) throws {
    UserDefaults.standard.set(allow, forKey: key)
  }

  public func isBiometricUsageAllowed() throws -> Bool {
    UserDefaults.standard.bool(forKey: key)
  }

}
