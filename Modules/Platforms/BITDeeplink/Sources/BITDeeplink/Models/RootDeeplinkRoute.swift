import Foundation

public enum RootDeeplinkRoute: DeeplinkRoute, CaseIterable {
  case credential

  public var schemes: [String] {
    switch self {
    case .credential:
      ["openid-credential-offer", "swiyu"]
    }
  }

  public var action: String {
    switch self {
    case .credential: "" // Credential invitation link does not have any action
    }
  }
}
