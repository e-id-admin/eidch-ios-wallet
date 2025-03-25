import Foundation

public protocol JWSDecoderProtocol {
  func decode<T>(_ type: T.Type, from data: Data) throws -> JWS<T> where T: JWTType & Decodable
}
