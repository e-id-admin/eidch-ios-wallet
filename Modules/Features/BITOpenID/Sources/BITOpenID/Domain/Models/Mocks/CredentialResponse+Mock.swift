#if DEBUG
import Foundation
@testable import BITTestingCore

// MARK: - CredentialResponse + Mockable

extension CredentialResponse: Mockable {

  struct Mock {
    static let sample: CredentialResponse = Mocker.decode(fromFile: "credential-response", bundle: Bundle.module)
    static let sampleData: Data = Mocker.getData(fromFile: "credential-response", bundle: Bundle.module) ?? Data()
    static let sampleWithVctNotAnURL: CredentialResponse = Mocker.decode(fromFile: "credential-response-vct-not-url", bundle: Bundle.module)
    static let sampleWithVctMismatch: CredentialResponse = Mocker.decode(fromFile: "credential-response-vct-mismatch", bundle: Bundle.module)
    static let sampleWithVctMissingIntegrity: CredentialResponse = Mocker.decode(fromFile: "credential-response-vct-missing-integrity", bundle: Bundle.module)
  }
}
#endif
