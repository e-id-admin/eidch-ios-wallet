#if DEBUG
import Foundation

@testable import BITTestingCore

// MARK: - CredentialResponse + Mockable

extension CredentialResponse: Mockable {

  struct Mock {
    static let sample: CredentialResponse = .decode(fromFile: "credential-response", bundle: Bundle.module)
    static let sampleData: Data = CredentialResponse.getData(fromFile: "credential-response", bundle: Bundle.module) ?? Data()
  }
}
#endif
