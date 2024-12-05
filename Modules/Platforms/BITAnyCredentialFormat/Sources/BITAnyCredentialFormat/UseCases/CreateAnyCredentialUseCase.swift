import BITSdJWT
import Factory
import Foundation

// MARK: - CreateAnyCredentialUseCase

struct CreateAnyCredentialUseCase: CreateAnyCredentialUseCaseProtocol {
  func execute(from payload: CredentialPayload, format: String) throws -> AnyCredential {
    guard let rawCredential = String(data: payload, encoding: .utf8) else {
      throw CreateAnyCredentialUseCaseError.credentialPayloadInvalid
    }

    guard let credentialFormat = CredentialFormat(rawValue: format) else {
      throw CreateAnyCredentialUseCaseError.credentialFormatNotSupported
    }

    switch credentialFormat {
    case .vcSdJwt:
      let vcSdJwt = try VcSdJwt(from: rawCredential)
      return vcSdJwt
    default:
      throw CreateAnyCredentialUseCaseError.credentialFormatNotSupported
    }
  }
}

// MARK: CreateAnyCredentialUseCase.CreateAnyCredentialUseCaseError

extension CreateAnyCredentialUseCase {
  enum CreateAnyCredentialUseCaseError: Error {
    case credentialPayloadInvalid
    case credentialFormatNotSupported
  }
}
