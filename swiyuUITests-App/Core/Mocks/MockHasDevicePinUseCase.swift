import BITAppAuth
import Foundation

struct MockHasDevicePinUseCase: HasDevicePinUseCaseProtocol {

  init(_ value: Bool = false) {
    self.value = value
  }

  private var value: Bool

  func execute() -> Bool {
    value
  }
}
