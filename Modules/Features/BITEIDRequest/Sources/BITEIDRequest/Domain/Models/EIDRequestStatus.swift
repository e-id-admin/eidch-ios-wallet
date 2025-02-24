import Foundation


struct EIDRequestStatus: Decodable, Equatable {
  let state: State
  let onlineSessionStartCloseAt: Date?
  let queueInformation: QueueInformation?

  private let legalRepresentant: LegalRepresentant?

  private enum CodingKeys: String, CodingKey {
    case state
    case queueInformation
    case legalRepresentant
    case onlineSessionStartCloseAt = "onlineSessionStartTimeout"
  }
}

#warning("TODO: Update when english values ready")
extension EIDRequestStatus {
  enum State: String, Decodable {
    case inQueue = "InQueueing"
    case readyForAV = "BereitFuerOnlineSession"
    case inTargetWalletPairing = "InTargetWalletPairing"
    case inAV = "InAutoVerifikation"
    case readyForReview = "BereitFuerAnspruchspruefung"
    case inAusstellung = "InAusstellung"
    case denied = "Abgelehnt"
    case cancelled = "Abgebrochen"
    case expired = "Abgelaufen"
    case closed = "Abgeschlossen"
  }

  struct QueueInformation: Decodable, Equatable {
    let onlineSessionStartOpenAt: Date

    private let position: Int
    private let total: Int

    private enum CodingKeys: String, CodingKey {
      case onlineSessionStartOpenAt = "expectedOnlineSessionStart"
      case position = "positionInQueue"
      case total = "totalInQueue"
    }
  }

  struct LegalRepresentant: Decodable, Equatable {
    private let isVerified: Bool
    private let verificationLink: String

    private enum CodingKeys: String, CodingKey {
      case isVerified = "verified"
      case verificationLink
    }
  }
}
