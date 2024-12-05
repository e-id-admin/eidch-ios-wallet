import BITCrypto
import Factory
import Foundation

struct PinCodeManager: PinCodeManagerProtocol {

  // MARK: Internal

  func encrypt(_ pinCode: PinCode) throws -> Data {
    try validatePinCodeRuleUseCase.execute(pinCode)
    let saltData = try saltRepository.getPinSalt()
    let pepperKey = try pepperRepository.getPepperKey()
    let initialVector = try pepperRepository.getPepperInitialVector()
    let pinData = try pinCode.asData()

    let saltedPinCodeData = try keyDeriver.deriveKey(from: pinData, with: saltData)
    return try encrypter.encrypt(
      saltedPinCodeData,
      withAsymmetricKey: pepperKey,
      length: encrypterLength,
      derivationAlgorithm: pepperKeyDerivationAlgorithm,
      initialVector: initialVector)
  }

  // MARK: Private

  @Injected(\.keyDeriver) private var keyDeriver: KeyDerivable
  @Injected(\.encrypter) private var encrypter: Encryptable
  @Injected(\.encrypterLength) private var encrypterLength: Int
  @Injected(\.pepperKeyDerivationAlgorithm) private var pepperKeyDerivationAlgorithm: SecKeyAlgorithm
  @Injected(\.saltRepository) private var saltRepository: SaltRepositoryProtocol
  @Injected(\.pepperRepository) private var pepperRepository: PepperRepositoryProtocol

  @Injected(\.validatePinCodeRuleUseCase) private var validatePinCodeRuleUseCase: ValidatePinCodeRuleUseCaseProtocol
}
