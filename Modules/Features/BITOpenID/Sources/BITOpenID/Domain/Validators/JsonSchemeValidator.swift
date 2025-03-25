import Foundation
import Spyable

// MARK: - JsonSchemaValidator

struct JsonSchemaValidator: JsonSchema {
  func validate(_ jsonObject: Data, with jsonSchema: Data) throws -> Bool {
    true
  }
}

// MARK: - JsonSchema

/// Providing functionality for working with JSON Schemas
/// https://json-schema.org/draft/2020-12/release-notes
@Spyable
public protocol JsonSchema {

  /// Validates the provided JSON object against the given JSON Schema
  ///
  /// - Parameters:
  ///   - jsonObject: The JSON object to be validated.
  ///   - jsonSchema: The raw JSON schema to be used for validation.
  ///
  /// - Throws:
  ///   - `JsonSchemaError.invalidSchema` if the schema cannot be parsed or is otherwise invalid.
  ///   - `JsonSchemaError.invalidJsonObject` if the JSON object data cannot be parsed.
  ///
  /// - Returns: `true` if the JSON object is valid according to the schema;
  ///             otherwise `false`.
  func validate(_ jsonObject: Data, with jsonSchema: Data) throws -> Bool
}
