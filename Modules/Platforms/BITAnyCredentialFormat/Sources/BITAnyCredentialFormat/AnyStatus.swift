import Foundation

// MARK: - AnyStatus

public protocol AnyStatus {
  var type: AnyStatusType { get }
}

// MARK: - AnyStatusType

public enum AnyStatusType: String {
  case tokenStatusList
}
