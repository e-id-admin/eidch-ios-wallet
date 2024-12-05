import Foundation

extension JSONSerialization {

  // MARK: Internal

  /// This method ensure that Boolean and Int are correctly interpreted
  /// Because the standard ´jsonObject´ function will convert "true" as an 1 and "false" as a 0
  class func customJsonObject(
    with data: Data,
    options opt: JSONSerialization.ReadingOptions = []) throws
    -> Any
  {
    let object = try JSONSerialization.jsonObject(with: data, options: opt)
    return try convertToIntendedTypes(object: object)
  }

  // MARK: Private

  private class func convertToIntendedTypes(object: Any) throws -> Any {
    if let array = object as? [Any] {
      return try array.map { try convertToIntendedTypes(object: $0) }
    }

    if let dictionary = object as? [String: Any] {
      return dictionary.reduce(into: [String: Any]()) { result, keyValue in
        let (key, value) = keyValue
        result[key] = try? convertToIntendedTypes(object: value)
      }
    }

    guard
      let number = object as? NSNumber,
      CFGetTypeID(number) == CFBooleanGetTypeID()
    else { return object }
    return number.boolValue
  }
}
