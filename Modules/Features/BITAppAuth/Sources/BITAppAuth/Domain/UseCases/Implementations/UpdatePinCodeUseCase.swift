import BITLocalAuthentication
import Factory
import Foundation

struct UpdatePinCodeUseCase: UpdatePinCodeUseCaseProtocol {

  // MARK: Lifecycle

  init(
    uniquePassphraseManager: UniquePassphraseManagerProtocol = Container.shared.uniquePassphraseManager(),
    context: LAContextProtocol = Container.shared.authContext(),
    pinCodeManager: PinCodeManagerProtocol = Container.shared.pinCodeManager(),
    contextManager: ContextManagerProtocol = Container.shared.contextManager())
  {
    self.uniquePassphraseManager = uniquePassphraseManager
    self.context = context
    self.contextManager = contextManager
    self.pinCodeManager = pinCodeManager
  }

  // MARK: Internal

  func execute(with newPinCode: PinCode, and uniquePassphrase: Data) throws {
    let newPinCodeDataEncrypted = try pinCodeManager.encrypt(newPinCode)
    try contextManager.setCredential(newPinCodeDataEncrypted, context: context)

    try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .appPin, context: context)
    try contextManager.setCredential(uniquePassphrase, context: context)
  }

  // MARK: Private

  private let context: LAContextProtocol
  private let contextManager: ContextManagerProtocol
  private let pinCodeManager: PinCodeManagerProtocol
  private let uniquePassphraseManager: UniquePassphraseManagerProtocol

}
