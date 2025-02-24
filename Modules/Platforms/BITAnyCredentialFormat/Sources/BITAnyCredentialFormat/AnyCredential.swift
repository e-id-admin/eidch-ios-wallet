import Foundation
import Spyable

public typealias CredentialPayload = Data

// MARK: - AnyCredential

@Spyable
public protocol AnyCredential {
  var format: String { get }
  var raw: String { get }
  var issuer: String { get }
  var claims: [any AnyClaim] { get }
  var status: (any AnyStatus)? { get }
  var validUntil: Date? { get }
}
