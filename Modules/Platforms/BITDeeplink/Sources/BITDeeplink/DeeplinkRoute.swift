import Foundation

public protocol DeeplinkRoute: Equatable {
  var schemes: [String] { get }
  var action: String { get }
}
