#if DEBUG
import Foundation
@testable import BITTestingCore

extension CredentialClaim {

  struct Mock {
    static var array: [CredentialClaim] = [CredentialClaim(key: "key1", value: "value1", credentialId: UUID()), CredentialClaim(key: "key2", value: "value2", credentialId: UUID())]
  }

}
#endif
