import Foundation

// MARK: - CredentialRequestBody

public struct CredentialRequestBody: Codable {

  var format: String
  let proof: CredentialRequestProof?
  let credentialDefinition: CredentialRequestBodyDefinition

  enum CodingKeys: String, CodingKey {
    case format
    case proof
    case credentialDefinition = "credential_definition"
  }
}

// MARK: CredentialRequestBody.Mock

extension CredentialRequestBody {

  func asDictionary() -> [String: Any] {
    var dictionary = [
      "format": format,
      "credential_definition": [
        "types": credentialDefinition.types,
      ],
    ] as [String: Any]
    if let safeProof = proof {
      dictionary["proof"] = [
        "proof_type": safeProof.proofType,
        "jwt": safeProof.jwt,
      ]
    }
    return dictionary
  }
}

// MARK: - CredentialRequestProof

struct CredentialRequestProof: Codable {
  let jwt: String
  let proofType: String

  init(jwt: String) {
    self.jwt = jwt
    proofType = Type.jwt.rawValue
  }

  enum CodingKeys: String, CodingKey {
    case jwt
    case proofType = "proof_type"
  }

  private enum `Type`: String, Codable {
    case jwt
  }
}

// MARK: - CredentialRequestBodyDefinition

struct CredentialRequestBodyDefinition: Codable, Equatable {
  let types: [String]
}
