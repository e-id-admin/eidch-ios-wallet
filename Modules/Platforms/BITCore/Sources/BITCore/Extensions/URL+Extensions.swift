import Foundation

extension URL {

  public var queryParameters: [String: String]? {
    guard
      let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
      let items = components.queryItems
    else { return nil }
    return items.reduce(into: [String: String]()) { $0[$1.name] = $1.value }
  }

}
