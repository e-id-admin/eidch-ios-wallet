import BITAppAuth
import Foundation

struct MockLoginPinCodeUseCase: LoginPinCodeUseCaseProtocol {
  func execute(from pinCode: PinCode) throws {
    NotificationCenter.default.post(name: .didLogin, object: nil)
  }
}
