import Foundation

public struct BundleAppVersionRepository: AppVersionRepositoryProtocol {
  private let appVersionKey = "CFBundleShortVersionString"
  private let buildNumberKey = "CFBundleVersion"

  public init() { /* empty */ }

  public func getVersion() throws -> String {
    guard let version = Bundle.main.infoDictionary?[appVersionKey] as? String else { throw AppVersionError.notFound }
    return version
  }

  public func getBuildNumber() throws -> Int {
    guard let buildNumber = Bundle.main.infoDictionary?[buildNumberKey] as? String else { throw AppVersionError.notFound }
    return Int(buildNumber) ?? -1
  }

}
