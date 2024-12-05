import BITCore
import Foundation

// MARK: - AppVersion

public struct AppVersion: Equatable, Comparable {

  // MARK: Lifecycle

  public init(_ version: String) {
    rawValue = version
    (major, minor, patch) = AppVersion.parse(version, pattern: regex)
  }

  // MARK: Public

  public typealias Major = Int
  public typealias Minor = Int
  public typealias Patch = Int
  public typealias Version = (major: Major, minor: Minor, patch: Patch)

  public let rawValue: String

  public var version: Version {
    (major, minor, patch)
  }

  public static func == (lhs: AppVersion, rhs: AppVersion) -> Bool {
    lhs.major == rhs.major &&
      lhs.minor == rhs.minor &&
      lhs.patch == rhs.patch
  }

  public static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
    (lhs.major, lhs.minor, lhs.patch) < (rhs.major, rhs.minor, rhs.patch)
  }

  public static func > (lhs: AppVersion, rhs: AppVersion) -> Bool {
    (lhs.major, lhs.minor, lhs.patch) > (rhs.major, rhs.minor, rhs.patch)
  }

  // MARK: Internal

  enum VersionKind: String, CaseIterable {
    case major
    case minor
    case patch
  }

  let major: Major
  let minor: Minor
  let patch: Patch

  // MARK: Private

  private let regex: String = #"(?<major>\d+)(.(?<minor>\d+))?(.(?<patch>\d+))?"#

  private static func parse(_ version: String, pattern: String) -> Version {
    var finalVersion: Version = (0, 0, 0)
    guard let match = RegexHelper.firstMatch(pattern, in: version) else {
      return finalVersion
    }

    for name in VersionKind.allCases {
      let range = match.range(withName: name.rawValue)
      guard let substringRange = Range(range, in: version) else { continue }
      let capture = String(version[substringRange])
      switch name {
      case .major:
        finalVersion.major = Int(capture) ?? 0
      case .minor:
        finalVersion.minor = Int(capture) ?? 0
      case .patch:
        finalVersion.patch = Int(capture) ?? 0
      }
    }

    return finalVersion
  }

}

// MARK: AppVersion.Mock

extension AppVersion {
  public enum Mock {
    public static let sample: AppVersion = .init("1.2.3")
  }
}
