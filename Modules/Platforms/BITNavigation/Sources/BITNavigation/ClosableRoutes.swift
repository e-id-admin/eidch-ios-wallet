import Foundation
import Spyable

// MARK: - ClosableRoutes

@Spyable
public protocol ClosableRoutes: AnyObject {
  func close(onComplete: (() -> Void)?)
  func close()
  func pop()
  func pop(number: Int)
  func popToRoot()
  func dismiss()
}
