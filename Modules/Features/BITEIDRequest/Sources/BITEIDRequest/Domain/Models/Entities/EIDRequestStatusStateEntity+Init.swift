import BITEntities

extension EIDRequestStatusStateEntity {

  init(_ state: EIDRequestStatus.State) {
    switch state {
    case .inQueue:
      self = .inQueue
    case .readyForOnlineSession:
      self = .readyForOnlineSession
    case .inTargetWalletPairing:
      self = .inTargetWalletPairing
    case .inAutoVerification:
      self = .inAutoVerification
    case .readyForEntitlementCheck:
      self = .readyForEntitlementCheck
    case .inIssuing:
      self = .inIssuing
    case .denied:
      self = .denied
    case .cancelled:
      self = .cancelled
    case .expired:
      self = .expired
    case .closed:
      self = .closed
    case .unknown:
      self = .unknown
    }
  }
}
