import BITSecurity
import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - JailbreakScene

@MainActor
final class JailbreakScene: SceneManagerProtocol {

  // MARK: Lifecycle

  init() {}

  // MARK: Internal

  weak var delegate: (any SceneManagerDelegate)?

  func viewController() -> UIViewController {
    UIHostingController(rootView: JailbreakView())
  }

}
