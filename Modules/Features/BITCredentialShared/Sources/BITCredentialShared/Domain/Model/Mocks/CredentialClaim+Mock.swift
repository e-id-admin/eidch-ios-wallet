#if DEBUG
import Foundation

@testable import BITCredentialShared
@testable import BITTestingCore

extension CredentialClaim {

  struct Mock {
    static var array: [CredentialClaim] = [.init(key: "test", value: "1234", credentialId: Credential.Mock.sample.id)]
  }

}
#endif
