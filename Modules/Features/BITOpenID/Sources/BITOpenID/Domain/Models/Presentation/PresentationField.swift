import BITCore
import Foundation

// MARK: - PresentationField

public struct PresentationField: Equatable {

  // MARK: Lifecycle

  public init(jsonPath: String, value: CodableValue) {
    self.jsonPath = jsonPath
    self.value = value
  }

  // MARK: Public

  public let jsonPath: String

  public let value: CodableValue

  public var key: String {
    // we currently only support flat hierarchies so just split path to have the key
    guard let lastPart = jsonPath.split(separator: ".").last else { return jsonPath }
    return String(lastPart)
  }

}
