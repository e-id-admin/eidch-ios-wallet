import BITSdJWT
import Foundation

// MARK: - TokenStatusList + AnyStatus

extension TokenStatusList: AnyStatus {

  public var type: AnyStatusType {
    AnyStatusType.tokenStatusList
  }

}
