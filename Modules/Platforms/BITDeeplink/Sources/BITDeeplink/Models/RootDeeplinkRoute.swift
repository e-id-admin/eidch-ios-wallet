import Foundation

public enum RootDeeplinkRoute: DeeplinkRoute, CaseIterable {
  case credential

  public var scheme: String {
    switch self {
    case .credential:
      "openid-credential-offer"
    }
  }

  public var action: String {
    switch self {
    case .credential: "" // Credential invitation link does not have any action
    }
  }
}
