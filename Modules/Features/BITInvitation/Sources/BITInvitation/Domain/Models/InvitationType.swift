import Foundation

// MARK: - InvitationType

public enum InvitationType {
  case credentialOffer
  case presentation
}

extension InvitationType {
  var scheme: String {
    switch self {
    case .credentialOffer:
      return "openid-credential-offer"
    case .presentation:
      return "https"
    }
  }
}
