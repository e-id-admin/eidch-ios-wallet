import BITAnyCredentialFormat
import Foundation
import Spyable

// MARK: - AnyStatusCheckValidatorProtocol

@Spyable
public protocol AnyStatusCheckValidatorProtocol {
  func validate(_ anyStatus: any AnyStatus, issuer: String) async -> VcStatus
}
