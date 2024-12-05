import BITLocalAuthentication
import Foundation

public typealias Query = [String: Any]

extension Query {

  mutating func mergeWith(_ query: Query) {
    merge(query) { builderQuery, _ in
      builderQuery
    }
  }

  mutating func setContext(_ context: LAContextProtocol?, reason: String? = nil) {
    guard var context else {
      return
    }

    self[kSecUseAuthenticationContext as String] = context
    if let reason {
      context.localizedReason = reason
    }
  }
}
