import BITCrypto
import Factory

// MARK: - JWTSignatureValidator

public struct JWTSignatureValidator: JWTSignatureValidatorProtocol {

  // MARK: Public

  public func validate(_ jwt: JWT) async throws -> Bool {
    guard let issuer = jwt.iss else {
      return false
    }

    return try await validate(jwt, from: issuer)
  }

  public func validate(_ jwt: JWT, from did: String) async throws -> Bool {
    try await validateJwt(jwt, from: did)
  }

  // MARK: Private

  @Injected(\.didResolverHelper) private var didResolverHelper: DidResolverHelperProtocol
  @Injected(\.jwtHelper) private var jwtHelper: JWTHelperProtocol

  private func validateJwt(_ jwt: JWT, from did: String) async throws -> Bool {
    let jwks = try await didResolverHelper.getJWKS(from: did)

    for jwk in jwks where validateJwtSignature(for: jwt, jwk: jwk) {
      return true
    }
    return false
  }

  private func validateJwtSignature(for jwt: JWT, jwk: PublicKeyInfo.JWK) -> Bool {
    guard let secKey = try? jwtHelper.getSecKey(curve: jwk.crv, x: jwk.x, y: jwk.y) else {
      return false
    }

    return jwtHelper.hasValidSignature(jwt: jwt, using: secKey)
  }

}
