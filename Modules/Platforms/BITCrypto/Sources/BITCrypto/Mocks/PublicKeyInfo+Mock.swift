#if DEBUG
import Foundation

@testable import BITTestingCore

// MARK: - PublicKeyInfo + Mockable

extension PublicKeyInfo: Mockable {
  struct Mock {
    static let sample: PublicKeyInfo = .decode(fromFile: "jwks", bundle: Bundle.module)
    static let sampleData: Data = PublicKeyInfo.getData(fromFile: "jwks", bundle: Bundle.module) ?? Data()
    static let samplesMultiple: PublicKeyInfo = .decode(fromFile: "jwks-multiple", bundle: Bundle.module)
  }
}

// MARK: - PublicKeyInfo.JWK + Mockable

extension PublicKeyInfo.JWK: Mockable {
  struct Mock {
    static let validSample: PublicKeyInfo.JWK = .decode(fromFile: "valid-jwk", bundle: Bundle.module)
    static let invalidSample: PublicKeyInfo.JWK = .decode(fromFile: "valid-jwk", bundle: Bundle.module)
  }
}
#endif
