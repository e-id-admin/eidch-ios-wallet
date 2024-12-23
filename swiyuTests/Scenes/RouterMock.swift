import BITNavigation
import Foundation
@testable import swiyu

class RootRouterMock: RootRouterRoutes {

  var didCallLogin = false
  var didCallSplashScreen = false
  var didCallDeeplink = false
  var didCallInvitation = false
  var didCallCamera = false

  func login(animated: Bool) {
    didCallLogin = true
  }

  func splashScreen(_ completed: @escaping () -> Void) {
    didCallSplashScreen = true
  }

  func deeplink(url: URL, animated: Bool) -> Bool {
    didCallDeeplink = true
    return true
  }

  func invitation() {
    didCallInvitation = true
  }

  func camera(openingStyle: any OpeningStyle) {
    didCallCamera = true
  }

}
