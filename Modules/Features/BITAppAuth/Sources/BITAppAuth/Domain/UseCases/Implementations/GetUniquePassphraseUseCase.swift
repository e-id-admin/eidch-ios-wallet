import BITLocalAuthentication
import Factory
import Foundation

struct GetUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol {

  // MARK: Internal

  func execute(from pinCode: PinCode) throws -> Data {
    let pinCodeDataEncrypted = try pinCodeManager.encrypt(pinCode)
    guard internalContext.setCredential(pinCodeDataEncrypted, type: .applicationPassword) else {
      throw AuthError.LAContextError(reason: "cannot set the required credential to get unique passphrase")
    }
    return try uniquePassphraseManager.getUniquePassphrase(authMethod: .appPin, context: internalContext)
  }

  // MARK: Private

  @Injected(\.internalContext) private var internalContext: LAContextProtocol
  @Injected(\.pinCodeManager) private var pinCodeManager: PinCodeManagerProtocol
  @Injected(\.uniquePassphraseManager) private var uniquePassphraseManager: UniquePassphraseManagerProtocol
}
