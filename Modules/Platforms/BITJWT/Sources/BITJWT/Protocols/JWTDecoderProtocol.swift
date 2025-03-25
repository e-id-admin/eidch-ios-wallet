import Foundation
import JOSESwift
import Spyable

@Spyable
public protocol JWTDecoderProtocol {
  func decodeJWS(from rawJWT: String) throws -> JOSESwift.JWS
  func decodeAlgorithm(from rawJWT: String) throws -> String
  func decodeType(from rawJWT: String) -> String?
  func decodeKid(from rawJWT: String) -> String?
  func decodePayload(from rawJWT: String) -> Data?
  func decodeTimestamp(from rawJWT: String, with key: String) -> Date?
  func decodeStringField(from rawJWT: String, with key: String) -> String?
}
