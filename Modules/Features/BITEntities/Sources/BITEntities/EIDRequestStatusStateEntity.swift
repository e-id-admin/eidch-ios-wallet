import RealmSwift

public enum EIDRequestStatusStateEntity: String, PersistableEnum {
  case inQueue
  case readyForOnlineSession
  case inTargetWalletPairing
  case inAutoVerification
  case readyForEntitlementCheck
  case inIssuing
  case denied
  case cancelled
  case expired
  case closed
  case unknown
}
