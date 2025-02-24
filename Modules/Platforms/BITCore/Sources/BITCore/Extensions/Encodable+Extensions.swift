import Foundation

extension Encodable {
  public func asDictionary() -> [String: Any] {
    guard
      let jsonData = try? JSONEncoder().encode(self),
      let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
    else {
      return [:]
    }

    return dictionary
  }
}
