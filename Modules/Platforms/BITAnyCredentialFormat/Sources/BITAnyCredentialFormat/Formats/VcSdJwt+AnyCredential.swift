import BITSdJWT
import Foundation

// MARK: - VcSdJwt + AnyCredential

extension VcSdJwt: AnyCredential {

  public var format: String {
    CredentialFormat.vcSdJwt.rawValue
  }

  public var issuer: String {
    vcIssuer
  }

  public var claims: [any AnyClaim] {
    disclosableClaims
  }

  public var status: (any AnyStatus)? {
    statusList
  }
}

// MARK: - SdJWTClaim + AnyClaim

extension SdJWTClaim: AnyClaim {}
