import Foundation
import SwiftUI

extension ControlSize {

  // MARK: Public

  public static func > (a: ControlSize, b: ControlSize) -> Bool {
    a.rank > b.rank
  }

  public static func < (a: ControlSize, b: ControlSize) -> Bool {
    a.rank < b.rank
  }

  // MARK: Private

  private var rank: Int {
    switch self {
    case .mini: 1
    case .small: 2
    case .regular: 3
    case .large: 4
    case .extraLarge: 5
    @unknown default: 10
    }
  }

}
