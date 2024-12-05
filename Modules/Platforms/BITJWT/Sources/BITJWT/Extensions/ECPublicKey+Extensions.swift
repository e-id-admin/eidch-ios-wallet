import Foundation
import JOSESwift

extension ECPublicKey {

  static func getSecKey(curve: String, x: String, y: String) throws -> SecKey? {
    guard let curve = ECCurveType(rawValue: curve) else { throw ECPublicKeyError.invalidInputData }

    let publicKey = ECPublicKey(crv: curve, x: x, y: y)

    return try publicKey.converted(to: SecKey.self)
  }

  func base64String() -> String? {
    jsonString()?.data(using: .utf8)?.base64EncodedString()
  }
}

// MARK: - ECPublicKeyError

enum ECPublicKeyError: Error {
  case invalidInputData
}
