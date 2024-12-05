import Foundation
import Spyable

// MARK: - ProcessInfoServiceProtocol

@Spyable
public protocol ProcessInfoServiceProtocol {
  var systemUptime: TimeInterval { get }
}

// MARK: - ProcessInfoService

struct ProcessInfoService: ProcessInfoServiceProtocol {
  var systemUptime: TimeInterval {
    ProcessInfo().systemUptime
  }
}
