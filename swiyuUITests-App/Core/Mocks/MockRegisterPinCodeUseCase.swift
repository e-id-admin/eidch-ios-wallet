import BITAppAuth
import Foundation

struct MockRegisterPinCodeUseCase: RegisterPinCodeUseCaseProtocol {
  func execute(pinCode: BITAppAuth.PinCode) throws {
    // nothing
  }
}
