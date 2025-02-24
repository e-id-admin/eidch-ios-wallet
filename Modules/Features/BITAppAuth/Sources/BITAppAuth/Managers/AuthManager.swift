import Foundation
import Spyable

// MARK: - AuthManagerProtocol

@Spyable
public protocol AuthManagerProtocol {
  var isLoggedIn: Bool { get }
  var isLoginRequired: Bool { get }

  func entersBackgroundState()
  func registerLogin()
}

// MARK: - AuthManager

public class AuthManager: AuthManagerProtocol {

  // MARK: Lifecycle

  public init(loginRequiredAfterIntervalThreshold: TimeInterval, backgroundStateDate: Date? = nil) {
    self.loginRequiredAfterIntervalThreshold = loginRequiredAfterIntervalThreshold
    self.backgroundStateDate = backgroundStateDate
  }

  // MARK: Public

  public var isLoggedIn: Bool {
    !isLoginRequired
  }

  public var isLoginRequired: Bool {
    var value = false
    if
      let interval = backgroundStateDate?.timeIntervalSince(Date()),
      interval < -loginRequiredAfterIntervalThreshold
    {
      value.toggle()
    }
    return value
  }

  public func entersBackgroundState() {
    backgroundStateDate = Date()
  }

  public func registerLogin() {
    backgroundStateDate = nil
  }

  // MARK: Private

  private var loginRequiredAfterIntervalThreshold: TimeInterval
  private var backgroundStateDate: Date?

}
