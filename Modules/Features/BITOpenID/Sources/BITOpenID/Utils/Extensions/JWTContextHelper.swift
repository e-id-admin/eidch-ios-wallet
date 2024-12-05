import BITCrypto
import BITJWT
import Factory
import Foundation
import Spyable

// MARK: - JWTContextHelperProtocol

@Spyable
protocol JWTContextHelperProtocol {
  var jwtHelper: JWTHelperProtocol { get }

  func jwt(using context: FetchCredentialContext, keyPair: KeyPair, type: String) throws -> JWT
}

// MARK: - JWTContextHelper

struct JWTContextHelper: JWTContextHelperProtocol {

  // MARK: Lifecycle

  init(jwtHelper: JWTHelperProtocol = Container.shared.jwtHelper()) {
    self.jwtHelper = jwtHelper
  }

  // MARK: Internal

  let jwtHelper: any JWTHelperProtocol

  func jwt(using context: FetchCredentialContext, keyPair: KeyPair, type: String) throws -> JWT {
    let jwtPayload = JWTPayload(audience: context.credentialIssuer, nonce: context.accessToken.cNonce, issuedAt: UInt64(context.createdAt.timeIntervalSince1970))
    let payload = try JSONEncoder().encode(jwtPayload)

    return try jwtHelper.jwt(with: payload, keyPair: keyPair, type: type)
  }

}
