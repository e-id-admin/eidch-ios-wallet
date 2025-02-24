import Foundation

extension JSONDecoder {

  public convenience init(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) {
    self.init()
    self.dateDecodingStrategy = dateDecodingStrategy
  }
}
