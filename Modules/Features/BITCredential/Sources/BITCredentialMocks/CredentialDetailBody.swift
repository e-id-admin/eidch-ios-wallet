import Foundation
@testable import BITCredential
@testable import BITTestingCore

// MARK: - CredentialDetailBody + Mockable

extension CredentialDetailBody: Mockable {
  struct Mock {
    static var sample: CredentialDetailBody = .init(
      display: .init(id: .init(), name: "BIT"), claims: [
        .init(id: .init(), key: "name", value: "Max", type: .string),
        .init(id: .init(), key: "Birth date", value: "1990-01-01", type: .string),
        .init(id: .init(), key: "signatureImage", value: "******", type: .imagePng),
      ], status: .valid)
  }
}
