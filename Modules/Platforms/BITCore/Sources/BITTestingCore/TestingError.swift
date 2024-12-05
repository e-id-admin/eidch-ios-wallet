#if DEBUG
import Foundation

// MARK: - TestingError

enum TestingError: Error {
  case error
}

// MARK: CustomStringConvertible

extension TestingError: CustomStringConvertible {
  var description: String {
    switch self {
    case .error: "error"
    }
  }
}
#endif
