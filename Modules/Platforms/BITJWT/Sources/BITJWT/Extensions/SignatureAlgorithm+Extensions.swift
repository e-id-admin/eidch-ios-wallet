import Foundation
import JOSESwift

extension SignatureAlgorithm {

  init(from jwtAlgorithm: JWTAlgorithm) throws {
    guard let signatureAlgorithm: SignatureAlgorithm = .init(rawValue: jwtAlgorithm.rawValue) else {
      throw JWTAlgorithm.AlgorithmError.signatureAlgorithmCreationError
    }
    self = signatureAlgorithm
  }

}
