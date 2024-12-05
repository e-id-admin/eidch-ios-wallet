#if DEBUG
import BITTestingCore
import Foundation

extension VersionEnforcement: Mockable {
  public struct Mock {
    public static let highMinVersionSample: VersionEnforcement = .decode(fromFile: "high-min-version-sample", bundle: .module)
    public static let noMinVersionSample: VersionEnforcement = .decode(fromFile: "no-min-version-sample", bundle: .module)
    public static let maxVersionSample: VersionEnforcement = .decode(fromFile: "max-version-sample", bundle: .module)
    public static let lowPrioritySample: VersionEnforcement = .decode(fromFile: "low-priority-sample", bundle: .module)
    public static let otherPlatformSample: VersionEnforcement = .decode(fromFile: "other-platform-sample", bundle: .module)
    public static let sample: VersionEnforcement = .decode(fromFile: "sample", bundle: .module)
    public static let noDisplaysSample: VersionEnforcement = .decode(fromFile: "no-displays-sample", bundle: .module)
  }
}
#endif
