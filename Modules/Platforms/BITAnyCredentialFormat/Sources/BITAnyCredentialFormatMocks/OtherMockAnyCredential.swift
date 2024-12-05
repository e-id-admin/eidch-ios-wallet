import BITAnyCredentialFormat
import BITCore
import Foundation

public struct OtherMockAnyCredential: AnyCredential {
  public var raw: String {
    "mock value"
  }

  public var format: String = "unknown_format"

  public var claims: [any AnyClaim] {
    []
  }

  public var issuer: String {
    ""
  }

  public var status: (any BITAnyCredentialFormat.AnyStatus)? {
    nil
  }
}
