import Foundation

@testable import BITAnyCredentialFormat
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore

extension CredentialPayload: Mockable {
  struct Mock {
    static let `default`: CredentialPayload = VcSdJwt.Mock.sampleData
    static let noKeyBinding: CredentialPayload = .getData(fromFile: "raw-credential-jwt-no-key-binding", ofType: "txt", bundle: .module) ?? Data()
  }
}
