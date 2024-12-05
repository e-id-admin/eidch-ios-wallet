import Foundation
import Spyable

@Spyable
public protocol HasDevicePinUseCaseProtocol {
  func execute() -> Bool
}
