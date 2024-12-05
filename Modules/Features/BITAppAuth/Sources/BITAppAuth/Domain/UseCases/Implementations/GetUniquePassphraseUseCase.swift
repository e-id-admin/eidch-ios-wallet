import BITLocalAuthentication
import Factory
import Foundation

struct GetUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol {

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

  func execute(from pinCode: PinCode) throws -> Data {
    let pinCodeDataEncrypted = try pinCodeManager.encrypt(pinCode)
    try contextManager.setCredential(pinCodeDataEncrypted, context: context)

    return try uniquePassphraseManager.getUniquePassphrase(authMethod: .appPin, context: context)
  }

  // MARK: Private

  private let context: LAContextProtocol
  private let contextManager: ContextManagerProtocol
  private let pinCodeManager: PinCodeManagerProtocol
  private let uniquePassphraseManager: UniquePassphraseManagerProtocol
}
