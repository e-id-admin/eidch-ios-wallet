import BITCore
import Factory
import UIKit

// MARK: - UserInactivityRunner

class UserInactivityRunner: ApplicationRunnerProtocol {

  // MARK: Lifecycle

  init(timeoutInterval: TimeInterval = Container.shared.userInactivityTimeout()) {
    self.timeoutInterval = timeoutInterval

    resetInactivityTimer()
  }

  // MARK: Internal

  func sendEvent(_ event: UIEvent) {
    if inactivityTimer != nil {
      resetInactivityTimer()
    }

    if let touches = event.allTouches {
      for touch in touches where touch.phase == UITouch.Phase.began {
        self.resetInactivityTimer()
      }
    }
  }

  // MARK: Private

  private var inactivityTimer: Timer?
  private var timeoutInterval: TimeInterval = Container.shared.userInactivityTimeout()

  private func resetInactivityTimer() {
    if let inactivityTimer {
      inactivityTimer.invalidate()
    }

    inactivityTimer = Timer.scheduledTimer(withTimeInterval: timeoutInterval, repeats: false, block: { [weak self] _ in self?.onTimeout() })
  }

  private func onTimeout() {
    NotificationCenter.default.post(name: .userInactivityTimeout, object: nil)
  }
}
