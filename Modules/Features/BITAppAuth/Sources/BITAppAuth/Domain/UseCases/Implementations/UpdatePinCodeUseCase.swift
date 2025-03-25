import BITLocalAuthentication
import Factory
import Foundation

struct UpdatePinCodeUseCase: UpdatePinCodeUseCaseProtocol {

  // MARK: Internal

  func execute(with newPinCode: PinCode, and uniquePassphrase: Data) throws {
    let newPinCodeDataEncrypted = try pinCodeManager.encrypt(newPinCode)
    let context = try userSession.startSession(passphrase: newPinCodeDataEncrypted)

    try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .appPin, context: context)

    try userSession.startSession(passphrase: uniquePassphrase)
  }

  // MARK: Private

  @Injected(\.userSession) private var userSession: Session
  @Injected(\.pinCodeManager) private var pinCodeManager: PinCodeManagerProtocol
  @Injected(\.uniquePassphraseManager) private var uniquePassphraseManager: UniquePassphraseManagerProtocol

}
