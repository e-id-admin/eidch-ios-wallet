import BITCore
import Foundation

// MARK: - SdJWTClaimError

enum SdJWTClaimError: Error {
  case invalidKey, invalidStructure, invalidValueType
}

// MARK: - SdJWTClaim

public struct SdJWTClaim: Equatable {

  // MARK: Lifecycle

  public init(disclosableClaim: [Any], disclosure: String, digest: SdJwtDigest) throws {
    guard disclosableClaim.count >= 3 else { throw SdJWTClaimError.invalidStructure }
    guard let key = disclosableClaim[1] as? String else { throw SdJWTClaimError.invalidKey }

    self.key = key
    self.digest = digest
    self.disclosure = disclosure
    value = try CodableValue(anyValue: disclosableClaim[2])
  }

  // MARK: Public

  public let digest: SdJwtDigest
  public let key: String
  public var value: CodableValue?
  public let disclosure: String
}

extension SdJWTClaim {
  public func anyValue() throws -> Any {
    switch value {
    case .string(let stringValue): stringValue
    case .int(let intValue): intValue
    case .double(let doubleValue): doubleValue
    case .bool(let boolValue): boolValue
    case .array(let arrayValue): arrayValue
    case .dictionary(let dictionaryValue): dictionaryValue
    case .none: throw SdJWTClaimError.invalidValueType
    }
  }
}
