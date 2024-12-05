import BITCore
import Foundation

// MARK: - RequestObject

/// A srtructure representing OpenID Authorization Request
/// https://openid.net/specs/openid-4-verifiable-presentations-1_0-20.html#name-authorization-request
public class RequestObject: Decodable {

  // MARK: Lifecycle

  init(presentationDefinition: PresentationDefinition, nonce: String?, responseUri: String, clientMetadata: ClientMetadata?, responseType: String, clientId: String, clientIdScheme: String?, responseMode: String) {
    self.presentationDefinition = presentationDefinition
    self.nonce = nonce
    self.responseUri = responseUri
    self.clientMetadata = clientMetadata
    self.responseType = responseType
    self.clientId = clientId
    self.clientIdScheme = clientIdScheme
    self.responseMode = responseMode
  }

  // MARK: Public

  public let presentationDefinition: PresentationDefinition
  public let nonce: String?
  public let responseUri: String
  public let clientMetadata: ClientMetadata?
  public let responseType: String
  public let clientId: String
  public let clientIdScheme: String?
  public let responseMode: String

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case presentationDefinition = "presentation_definition"
    case nonce
    case responseUri = "response_uri"
    case clientMetadata = "client_metadata"
    case responseType = "response_type"
    case clientId = "client_id"
    case clientIdScheme = "client_id_scheme"
    case responseMode = "response_mode"
  }

}

// MARK: Equatable

extension RequestObject: Equatable {
  public static func == (lhs: RequestObject, rhs: RequestObject) -> Bool {
    lhs.responseMode == rhs.responseMode &&
      lhs.clientIdScheme == rhs.clientIdScheme &&
      lhs.clientId == rhs.clientId &&
      lhs.responseType == rhs.responseType &&
      lhs.responseUri == rhs.responseUri &&
      lhs.nonce == rhs.nonce &&
      lhs.clientMetadata == rhs.clientMetadata &&
      lhs.presentationDefinition == rhs.presentationDefinition
  }
}

public typealias Verifier = ClientMetadata

// MARK: - ClientMetadata

public struct ClientMetadata: Decodable, Equatable {
  public let clientName: String?
  public let logoUri: URL?

  enum CodingKeys: String, CodingKey {
    case clientName = "client_name"
    case logoUri = "logo_uri"
  }
}

// MARK: - PresentationDefinition

/// https://identity.foundation/presentation-exchange/spec/v2.1.0/#presentation-definition

public struct PresentationDefinition: Decodable, Equatable {
  public let id: String
  public let name: String?
  public let purpose: String?
  public let inputDescriptors: [InputDescriptor]

  /// This format property seems to be the same as in the InputDescriptor

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case purpose
    case inputDescriptors = "input_descriptors"
  }
}

// MARK: - InputDescriptor

public struct InputDescriptor: Decodable, Equatable {

  // MARK: Lifecycle

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    name = try container.decodeIfPresent(String.self, forKey: .name)
    purpose = try container.decodeIfPresent(String.self, forKey: .purpose)
    constraints = try container.decode(Constraints.self, forKey: .constraints)

    var formats = [Format]()
    let formatContainer = try container.nestedContainer(keyedBy: Format.CodingKeys.self, forKey: .formats)

    if let vcSdJwt = try formatContainer.decodeIfPresent(VcSdJwtFormat.self, forKey: .vcSdJwt) {
      formats.append(.vcSdJwt(vcSdJwt))
    }

    self.formats = formats
  }

  // MARK: Public

  public let id: String
  public let name: String?
  public let purpose: String?
  public let formats: [Format]?
  public let constraints: Constraints

  public static func == (lhs: InputDescriptor, rhs: InputDescriptor) -> Bool {
    lhs.name == rhs.name &&
      lhs.purpose == rhs.purpose &&
      lhs.constraints == rhs.constraints &&
      lhs.id == rhs.id
  }

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case purpose
    case formats = "format"
    case constraints
  }
}

// MARK: - Constraints

public struct Constraints: Codable, Equatable {
  public let fields: [Field]?
  public let limitDisclosure: LimitDisclosure?

  enum CodingKeys: String, CodingKey {
    case fields
    case limitDisclosure = "limit_disclosure"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    fields = try container.decodeIfPresent([Field].self, forKey: .fields)
    limitDisclosure = try container.decodeIfPresent(LimitDisclosure.self, forKey: .limitDisclosure)

    guard let fields else { throw DecodingError.keyNotFound(CodingKeys.fields, .init(codingPath: [CodingKeys.fields], debugDescription: "Missing fields in constraints")) }
    guard !fields.isEmpty else { throw DecodingError.dataCorruptedError(forKey: .fields, in: container, debugDescription: "Fields must be present & contain at least a valid element") }
  }
}

// MARK: - Field

public struct Field: Codable, Equatable {

  // MARK: Lifecycle

  public init(path: [String], filter: Filter? = nil, id: String? = nil, purpose: String? = nil, name: String? = nil, optional: Bool? = nil) {
    self.path = path
    self.filter = filter
    self.id = id
    self.purpose = purpose
    self.name = name
    self.optional = optional
  }

  // MARK: Public

  public let path: [String]
  public let filter: Filter?
  public let id: String?
  public let purpose: String?
  public let name: String?
  public var optional: Bool?

  public func matching(valuesIn values: [Any]) -> [CodableValue] {
    if values.isEmpty { return [] }

    guard let pattern = filter?.pattern, let type = filter?.type else {
      return values.compactMap { try? CodableValue(anyValue: $0) }
    }

    return values.compactMap {
      let string = String(describing: $0)

      guard let range = string.range(of: pattern, options: .regularExpression) else {
        return nil
      }

      return CodableValue(value: String(string[range]), as: type)
    }
  }

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case path
    case filter
    case id
    case purpose
    case name
    case optional
  }

}

// MARK: - LimitDisclosure

public enum LimitDisclosure: String, Codable, Equatable {
  case required
  case preferred
}

// MARK: - Filter

public struct Filter: Codable, Equatable {
  public let type, pattern: String
}

// MARK: - Format

public enum Format: FormatType, Decodable {
  case vcSdJwt(FormatType)

  // MARK: Lifecycle

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    if let vcSdJwt = try container.decodeIfPresent(VcSdJwtFormat.self, forKey: .vcSdJwt) {
      self = .vcSdJwt(vcSdJwt)
    } else {
      throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.vcSdJwt], debugDescription: ""))
    }
  }

  // MARK: Public

  public var label: String {
    switch self {
    case .vcSdJwt(let type): type.label
    }
  }

  public var vcAlgorithm: [String]? {
    switch self {
    case .vcSdJwt(let type): type.vcAlgorithm
    }
  }

  public var keyBindingAlgorithm: [String]? {
    switch self {
    case .vcSdJwt(let type): type.keyBindingAlgorithm
    }
  }

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case vcSdJwt = "vc+sd-jwt"
  }

}

// MARK: - VcSdJwtFormat

/// https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-verifier-metadata
public struct VcSdJwtFormat: FormatType, Decodable, Equatable {
  public let vcAlgorithm: [String]?
  public let keyBindingAlgorithm: [String]?

  enum CodingKeys: String, CodingKey {
    case vcAlgorithm = "sd-jwt_alg_values"
    case keyBindingAlgorithm = "kb-jwt_alg_values"
  }

  public var label: String {
    "vc+sd-jwt"
  }
}

// MARK: - FormatType

public protocol FormatType: Decodable {
  var vcAlgorithm: [String]? { get }
  var keyBindingAlgorithm: [String]? { get }
  var label: String { get }
}
