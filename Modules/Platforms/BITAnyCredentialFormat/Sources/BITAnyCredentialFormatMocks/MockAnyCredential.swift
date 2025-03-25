import Foundation
@testable import BITAnyCredentialFormat
@testable import BITCore

/// VcSdJwt mocks represented as an AnyCredential type created from the CredentialPayload.Mock.default value
public struct MockAnyCredential: AnyCredential {

  // MARK: Lifecycle

  init(payload: Data = CredentialPayload.Mock.default) {
    self.payload = payload
  }

  // MARK: Public

  public var format = "vc+sd-jwt"

  public var raw: String {
    String(data: payload, encoding: .utf8) ?? UUID().uuidString
  }

  public var claims: [any AnyClaim] {
    [] // will be decoded by the VcSdJwtDecoder in the VcSdJwt init
  }

  public var issuer: String {
    "did:tdw:mock=:mock.swiyu.admin.ch:api:v1:did:25c2db14-8dc8-4e58-933f-070048079748"
  }

  public var status: (any BITAnyCredentialFormat.AnyStatus)? {
    nil
  }

  public var validFrom: Date? {
    nil
  }

  public var validUntil: Date? {
    nil
  }

  // MARK: Internal

  let payload: Data
}
