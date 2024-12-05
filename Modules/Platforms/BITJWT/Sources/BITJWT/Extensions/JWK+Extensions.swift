import Foundation
import JOSESwift

extension JWK {

  public static func toBase64String(from publicKey: SecKey) throws -> String {
    guard let value = try? ECPublicKey(publicKey: publicKey).base64String() else {
      throw ECPublicKeyError.invalidInputData
    }
    return value
  }

}
