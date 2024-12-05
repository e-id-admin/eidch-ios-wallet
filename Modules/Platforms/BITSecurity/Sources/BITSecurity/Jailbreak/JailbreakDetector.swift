import Foundation
import Spyable
import UIKit

// MARK: - JailbreakDetectorProtocol

@Spyable
public protocol JailbreakDetectorProtocol {
  func isDeviceJailbroken() -> Bool
}

// MARK: - JailbreakDetector

class JailbreakDetector: JailbreakDetectorProtocol {

  // MARK: Lifecycle

  init() {}

  // MARK: Internal

  func isDeviceJailbroken() -> Bool {
    detectors.contains { $0() }
  }

  // MARK: Private

  private lazy var detectors: [() -> Bool] = [
    isCydiaInstalled,
    canWriteOutsideSandbox,
    canAccessRestrictedPaths,
  ]

  private var restrictedPaths: [String] {
    [
      "/private/var/lib/apt",
      "/Applications/Cydia.app",
      "/private/var/lib/cydia",
      "/private/var/tmp/cydia.log",
      "/Applications/RockApp.app",
      "/Applications/Icy.app",
      "/Applications/WinterBoard.app",
      "/Applications/SBSetttings.app",
      "/Applications/blackra1n.app",
      "/Applications/IntelliScreen.app",
      "/Applications/Snoop-itConfig.app",
      "/usr/libexec/cydia/",
      "/usr/sbin/frida-server",
      "/usr/bin/cycript",
      "/usr/local/bin/cycript",
      "/usr/lib/libcycript.dylib",
      "/bin/sh",
      "/usr/libexec/sftp-server",
      "/usr/libexec/ssh-keysign",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/sbin/sshd",
      "/etc/apt",
      "/usr/bin/ssh",
      "/bin.sh",
      "/var/checkra1n.dmg",
      "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
      "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
      "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
      "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
    ]
  }

  private func canWriteOutsideSandbox() -> Bool {
    let testPath = "/private/jailbreaktest.txt"
    do {
      try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
      try FileManager.default.removeItem(atPath: testPath)
      return true
    } catch {
      return false
    }
  }

  private func canAccessRestrictedPaths() -> Bool {
    restrictedPaths.contains { FileManager.default.fileExists(atPath: $0) }
  }

  private func isCydiaInstalled() -> Bool {
    guard let cydiaUrl = URL(string: "cydia://") else { return false }
    return FileManager.default.fileExists(atPath: "/Applications/Cydia.app") || UIApplication.shared.canOpenURL(cydiaUrl)
  }

}

#if targetEnvironment(simulator)

// MARK: - SimulatorJailbreakDetector

class SimulatorJailbreakDetector: JailbreakDetectorProtocol {

  func isDeviceJailbroken() -> Bool {
    false
  }

}
#endif
