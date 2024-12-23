import Foundation
import Spyable
import UIKit

typealias SceneManagerProtocol = SceneManageable & SceneManagerInitable

// MARK: - SceneManagerInitable

@MainActor
protocol SceneManagerInitable {
  init()
}

// MARK: - SceneManageable

@Spyable
@MainActor
protocol SceneManageable {
  var delegate: SceneManagerDelegate? { get set }

  func viewController() -> UIViewController
  func willPresentScene(from scene: SceneManagerProtocol)
  func didPresentScene(from scene: SceneManagerProtocol)
  func willEnterForeground()
  func didEnterBackground()

  func didReceiveDeeplink(url: URL)
}

/// Default implementations of `SceneManagerProtocol`
extension SceneManageable {
  func willPresentScene(from scene: SceneManagerProtocol) {}
  func didPresentScene(from scene: SceneManagerProtocol) {}
  func willEnterForeground() {}
  func didReceiveDeeplink(url: URL) {}
  func didEnterBackground() {}
}

// MARK: - SceneManagerDelegate

@Spyable
protocol SceneManagerDelegate: AnyObject {
  func changeScene(to sceneManager: SceneManagerProtocol.Type, animated: Bool)
  func didConsumeDeeplink()
}

extension SceneManagerDelegate {
  public func changeScene(to sceneManager: SceneManagerProtocol.Type, animated: Bool = true) {
    changeScene(to: sceneManager, animated: animated)
  }
}
