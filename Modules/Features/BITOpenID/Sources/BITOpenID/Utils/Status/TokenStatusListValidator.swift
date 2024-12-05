import BITAnyCredentialFormat
import BITCrypto
import BITJWT
import BITSdJWT
import Factory
import Foundation

// MARK: - TokenStatusListValidator

/// A structure representing a validator that checks the revocation and suspension status of a credential.
/// This structure is based on the Token Status List specification.
/// https://www.ietf.org/archive/id/draft-ietf-oauth-status-list-03.html
///
struct TokenStatusListValidator: AnyStatusCheckValidatorProtocol {

  // MARK: Internal

  func validate(_ anyStatus: any AnyStatus, issuer: String) async -> VcStatus {
    do {
      guard
        let statusList = anyStatus as? TokenStatusList,
        let statusUri = URL(string: statusList.statusList.uri),
        let statusJwt = try? await repository.fetchCredentialStatus(from: statusUri),
        try await isValidStatusJwt(statusJwt, issuer: issuer, statusListUri: statusUri.absoluteString)
      else { return .unknown }

      let statusCode = try tokenStatusListDecoder.decode(statusJwt.raw, index: statusList.statusList.index)
      return statusCode.credentialStatus
    } catch {
      return .unknown
    }
  }

  // MARK: Private

  private static let statusListType: String = "statuslist+jwt"

  @Injected(\.openIDRepository) private var repository: OpenIDRepositoryProtocol
  @Injected(\.tokenStatusListDecoder) private var tokenStatusListDecoder: TokenStatusListDecoderProtocol
  @Injected(\.jwtSignatureValidator) private var jwtSignatureValidator: JWTSignatureValidatorProtocol

  private func isValidStatusJwt(_ jwt: JWT, issuer: String, statusListUri: String) async throws -> Bool {
    guard
      jwt.type == Self.statusListType,
      jwt.issuedAt != nil,
      jwt.subject == statusListUri,
      jwt.iss != nil,
      jwt.iss == issuer
    else {
      return false
    }
    guard try await jwtSignatureValidator.validate(jwt) else {
      return false
    }
    guard let expiredAt = jwt.expiredAt else { return true }
    return expiredAt > Date()
  }
}

extension StatusCode {
  var credentialStatus: VcStatus {
    switch self {
    case 0: return .valid
    case 1: return .revoked
    case 2: return .suspended
    default: return .unsupported
    }
  }
}
