import BITCrypto
import Factory

// MARK: - JWTSignatureValidator

public struct JWTSignatureValidator: JWTSignatureValidatorProtocol {

  // MARK: Public

  public func validate(_ jwt: JWT, did: String, kid: String) async throws -> Bool {
    let jwks: [PublicKeyInfo.JWK]
    do {
      jwks = try await didResolverHelper.getJWKS(from: did, keyIdentifier: kid)
    } catch {
      throw JWTSignatureValidatorError.cannotResolveDid(error)
    }

    for jwk in jwks where validateJwtSignature(for: jwt, jwk: jwk) {
      return true
    }

    return false
  }

  // MARK: Private

  @Injected(\.didResolverHelper) private var didResolverHelper: DidResolverHelperProtocol
  @Injected(\.jwtHelper) private var jwtHelper: JWTHelperProtocol

  private func validateJwtSignature(for jwt: JWT, jwk: PublicKeyInfo.JWK) -> Bool {
    guard let secKey = try? jwtHelper.getSecKey(curve: jwk.crv, x: jwk.x, y: jwk.y) else {
      return false
    }

    return jwtHelper.hasValidSignature(jwt: jwt, using: secKey)
  }
}

// MARK: JWTSignatureValidator.JWTSignatureValidatorError

extension JWTSignatureValidator {
  public enum JWTSignatureValidatorError: Error {
    case cannotResolveDid(_ error: Error)
  }
}
