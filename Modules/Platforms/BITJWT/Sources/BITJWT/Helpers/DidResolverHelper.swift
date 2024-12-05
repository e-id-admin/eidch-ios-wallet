import BITCrypto
import DidResolverSources
import DidResolverWrapper
import Factory
import Foundation
import Spyable

// MARK: - DidResolverHelperProtocol

@Spyable
protocol DidResolverHelperProtocol {
  func getJWKS(from did: String) async throws -> [PublicKeyInfo.JWK]
}

// MARK: - DidResolverHelperError

enum DidResolverHelperError: String, Error {
  case invalidDidUrl
}

// MARK: - DidResolverHelper

struct DidResolverHelper: DidResolverHelperProtocol {

  private func resolve(didRaw: String) async throws -> DidDoc {
    let did = Did(text: didRaw)
    guard let url = try URL(string: did.getUrl()) else { throw DidResolverHelperError.invalidDidUrl }
    let didLog = try await didResolverRepository.fetchDidLog(from: url)
    return try did.resolve(didTdwLog: didLog)
  }

  func getJWKS(from did: String) async throws -> [PublicKeyInfo.JWK] {
    let didDocument = try await resolve(didRaw: did)

    return didDocument.getVerificationMethod()
      .compactMap(\.publicKeyJwk)
      .compactMap({ .init(from: $0) })
  }

  @Injected(\.didResolverRepository) private var didResolverRepository: DidResolverRepositoryProtocol

}

extension PublicKeyInfo.JWK {

  fileprivate init?(from jwk: Jwk) {
    guard let x = jwk.x, let y = jwk.y, let crv = jwk.crv, let kty = jwk.kty else {
      return nil
    }

    self.init(kty: kty, kid: jwk.kid, crv: crv, x: x, y: y)
  }
}
