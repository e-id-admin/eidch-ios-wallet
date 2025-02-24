#if DEBUG
import Foundation
@testable import BITTestingCore

extension JWTRequestObject: Mockable {
  struct Mock {
    static let sample: JWTRequestObject = Mocker.decode(fromFile: "jwt-request-object-multipass", ofType: "json", bundle: Bundle.module)
    static let sampleWithoutKid: JWTRequestObject = Mocker.decode(fromFile: "jwt-request-object-without-kid", ofType: "json", bundle: Bundle.module)
    static let sampleWithUnsupportedAlgorithm: JWTRequestObject = Mocker.decode(fromFile: "jwt-request-object-unsupported-algo", ofType: "json", bundle: Bundle.module)
    static let jwtSampleData: Data = Mocker.getData(fromFile: "jwt-request-object-multipass", ofType: "txt", bundle: Bundle.module) ?? Data()
  }
}
#endif
