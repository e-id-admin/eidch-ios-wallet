import BITAnyCredentialFormat
import BITCore
import Sextant
import Spyable

// MARK: - AnyPresentationFieldsValidatorProtocol

@Spyable
public protocol AnyPresentationFieldsValidatorProtocol {
  func validate(_ anyCredential: AnyCredential, with requestedFields: [Field]) throws -> [CodableValue]
}

extension AnyPresentationFieldsValidatorProtocol {
  static func getMatchingFields(in rawCredential: String, using requestedFields: [Field]) throws -> [CodableValue] {
    var matchingFields: [CodableValue] = []
    for field in requestedFields {
      for path in field.path {
        guard
          let values = rawCredential.query(values: path),
          let matchingValues = try? field.matching(valuesIn: values)
        else {
          continue
        }
        matchingFields.append(contentsOf: matchingValues)
        break
      }
    }
    return matchingFields
  }
}
