#if DEBUG
import Foundation

@testable import BITTestingCore

// MARK: CredentialRequestBody.Mock

extension CredentialRequestBody: Mockable {

  struct Mock {
    static let sampleData: Data = CredentialRequestBody.getData(fromFile: "credential-request-body", bundle: Bundle.module) ?? Data()
    static let sample: CredentialRequestBody = .decode(fromFile: "credential-request-body", bundle: Bundle.module)
  }

}
#endif
