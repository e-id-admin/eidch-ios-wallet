import Foundation
@testable import BITCredential
@testable import BITTestingCore

// MARK: - CredentialDetailBody + Mockable

extension CredentialDetailBody: Mockable {
  struct Mock {
    static var sample = CredentialDetailBody(
      display: CredentialDetailBody.Display(id: UUID(), name: "BIT"), claims: [
        CredentialDetailBody.Claim(id: UUID(), key: "name", value: "Max", type: .string),
        CredentialDetailBody.Claim(id: UUID(), key: "Birth date", value: "1990-01-01", type: .string),
        CredentialDetailBody.Claim(id: UUID(), key: "signatureImage", value: "******", type: .imagePng),
      ], status: .valid)
  }
}
