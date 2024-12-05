import BITAnyCredentialFormat
import BITCore
import BITSdJWT

// MARK: - VcSdJwtPresentationFieldsValidator

struct VcSdJwtPresentationFieldsValidator: AnyPresentationFieldsValidatorProtocol {

  func validate(_ anyCredential: any AnyCredential, with requestedFields: [Field]) throws -> [CodableValue] {
    let vcSdJwt = try VcSdJwt(from: anyCredential.raw)
    let rawCredentialWithDisclosures = try vcSdJwt.replaceDigestsAndFindClaims()
    return try Self.getMatchingFields(in: rawCredentialWithDisclosures, using: requestedFields)
  }
}
