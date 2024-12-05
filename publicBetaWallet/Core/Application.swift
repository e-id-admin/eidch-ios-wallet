import UIKit

// MARK: - Application

final class Application: UIApplication {

  // MARK: Internal

  override func sendEvent(_ event: UIEvent) {
    super.sendEvent(event)
    for runner in runners {
      runner.sendEvent(event)
    }
  }

  // MARK: Private

  private var runners: [any ApplicationRunnerProtocol] = [
    UserInactivityRunner(),
  ]

}
