import BITCore
import BITCredentialShared
import Foundation

// MARK: - CompatibleCredential

public struct CompatibleCredential: Identifiable {

  // MARK: Lifecycle

  init(credential: Credential, requestedFields: [CodableValue]?) {
    self.credential = credential

    requestClaims = credential.claims.filter { claim in (requestedFields ?? []).contains { $0.rawValue == claim.value } }
  }

  // MARK: Public

  public let id: UUID = .init()

  let credential: Credential
  let requestClaims: [CredentialClaim]

}

// MARK: Equatable

extension CompatibleCredential: Equatable {}

#if DEBUG
extension CompatibleCredential {
  struct Mock {
    static let array: [CompatibleCredential] = [BIT, diploma]

    // swiftlint: disable all
    static var BIT: CompatibleCredential { .init(credential: .Mock.sample, requestedFields: [.init(value: "Fritz", as: "string"), .init(value: "Test", as: "string")]) }
    static var BITWithoutKeyBinding: CompatibleCredential { .init(credential: .Mock.sampleWithoutKeyBinding, requestedFields: [.init(value: "Fritz", as: "string"), .init(value: "Test", as: "string")]) }
    static var diploma: CompatibleCredential { .init(credential: .Mock.diploma, requestedFields: [.init(value: "lastName", as: "string")]) }
    // swiftlint: enable all
  }
}
#endif
