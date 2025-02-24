import BITAnyCredentialFormat
import BITJWT
import BITSdJWT

// MARK: - TrustStatementError

enum TrustStatementError: Error, Equatable {
  case keyNotFound(_ key: String)
}

// MARK: - TrustStatement

public class TrustStatement: VcSdJwt {

  override public init(from rawVcSdJwt: String) throws {
    try super.init(from: rawVcSdJwt)

    guard let typ = type, typ == CredentialFormat.vcSdJwt.rawValue else {
      throw TrustStatementError.keyNotFound("typ")
    }

    guard let alg = JWTAlgorithm(rawValue: algorithm), alg == .ES256 else {
      throw TrustStatementError.keyNotFound("alg")
    }

    if subject == nil && disclosableClaims.first(where: { $0.key == "sub" })?.value == nil {
      throw TrustStatementError.keyNotFound("sub")
    }

    if vct == nil && disclosableClaims.first(where: { $0.key == "vct" })?.value == nil {
      throw TrustStatementError.keyNotFound("vct")
    }

    if issuedAt == nil {
      throw TrustStatementError.keyNotFound("iat")
    }

    if activatedAt == nil {
      throw TrustStatementError.keyNotFound("nbf")
    }

    if expiredAt == nil {
      throw TrustStatementError.keyNotFound("exp")
    }

    if statusList == nil {
      throw TrustStatementError.keyNotFound("status")
    }
  }
}
