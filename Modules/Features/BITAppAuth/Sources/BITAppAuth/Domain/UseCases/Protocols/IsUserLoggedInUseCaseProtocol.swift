import Foundation
import Spyable

@Spyable
public protocol IsUserLoggedInUseCaseProtocol {
  func execute() -> Bool
}
