import Foundation

extension URL {

  public var queryParameters: [String: String]? {
    guard
      let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
      let items = components.queryItems
    else { return nil }
    return items.reduce(into: [String: String]()) { $0[$1.name] = $1.value }
  }

  public var isValidHttpUrl: Bool {
    let pattern = #/^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$/#
    let regex = Regex(pattern)
    return absoluteString.firstMatch(of: regex) != nil
  }

}
