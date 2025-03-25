import BITJWT
import Foundation

struct MockJWTSignatureValidator: JWTSignatureValidatorProtocol {

  init(_ value: Bool = false) {
    self.value = value
  }

  private var value: Bool

  func validate(_ jwt: BITJWT.JWT, did: String, kid: String) async throws -> Bool {
    value
  }
}
