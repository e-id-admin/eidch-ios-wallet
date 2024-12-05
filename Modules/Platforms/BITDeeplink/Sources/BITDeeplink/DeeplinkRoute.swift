import Foundation

public protocol DeeplinkRoute: Equatable {
  var scheme: String { get }
  var action: String { get }
}
