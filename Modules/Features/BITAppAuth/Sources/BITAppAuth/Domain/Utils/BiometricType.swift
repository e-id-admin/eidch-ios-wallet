import BITL10n
import Foundation
import SwiftUI

public enum BiometricType {
  case none
  case touchID
  case faceID

  // MARK: Lifecycle

  public init(type: BiometricType) {
    self = switch type {
    case .faceID: .faceID
    case .touchID: .touchID
    default: .none
    }
  }

  // MARK: Public

  public var text: String {
    switch self {
    case .faceID: L10n.biometricSetupFaceidText
    case .touchID: L10n.biometricSetupTouchidText
    case .none: "Biometrics"
    }
  }

  public var image: Image {
    switch self {
    case .faceID,
         .touchID: Image(systemName: icon)
    case .none: Image(systemName: "faceid")
    }
  }

  public var icon: String {
    switch self {
    case .faceID: "faceid"
    case .touchID: "touchid"
    case .none: "faceid"
    }
  }
}
