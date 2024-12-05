import Foundation

// MARK: - DataEncodingError

extension String {

  // MARK: Public

  public func asData(encoding: String.Encoding = .utf8) throws -> Data {
    guard let data: Data = data(using: encoding) else {
      throw DataEncodingError.cannotGenerateData
    }
    return data
  }

  // MARK: Private

  private enum DataEncodingError: Error {
    case cannotGenerateData
  }

}
